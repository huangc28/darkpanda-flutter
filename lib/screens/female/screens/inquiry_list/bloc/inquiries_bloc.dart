import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/util/util.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/api_client.dart';
import '../../../../../models/inquiry.dart';

part 'inquiries_event.dart';
part 'inquiries_state.dart';

class InquiriesBloc extends Bloc<InquiriesEvent, InquiriesState> {
  final ApiClient apiClient;

  InquiriesBloc({
    this.apiClient,
  }) : super(InquiriesState.initial());

  @override
  Stream<InquiriesState> mapEventToState(
    InquiriesEvent event,
  ) async* {
    if (event is FetchInquiries) {
      yield* _mapFetchInquiriesToState(event);
    }

    if (event is LoadMoreInquiries) {
      yield* _mapLoadMoreInquiries(event);
    }

    if (event is UpdateInquiryStatus) {
      yield* _mapUpdateInquiryStatusToState(event);
    }

    if (event is RemoveInquiry) {
      yield* _mapRemoveInquiryToState(event);
    }

    if (event is AddInquirySubscription) {
      yield* _mapAddInquirySubscriptionToState(event);
    }
  }

  Stream<InquiriesState> _mapFetchInquiriesToState(
      FetchInquiries event) async* {
    try {
      yield InquiriesState.fetching(state);
      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      final resp = await apiClient.fetchInquiries(
        offset: offset,
      );

      // If response status is not OK, emit fail event.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Normalize response with inquiry model.
      final dataMap = json.decode(resp.body);

      final parsedIqs = dataMap['inquiries']
          .map<Inquiry>((data) => Inquiry.fromJson(data))
          .toList();

      yield InquiriesState.fetched(
        state,
        inquiries: parsedIqs,
        currentPage: event.nextPage,
        hasMore: dataMap['has_more'],

        // We need to subscribe those inquiry with status `asking`. Organize an inquiry subscription map here.
        inquiryStreamMap: _createInquirySubscriptionStreamMap(parsedIqs),
      );
    } on APIException catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: e,
      );
    } on AppGeneralExeption catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.message,
        ),
      );
    }
  }

  Stream<InquiriesState> _mapLoadMoreInquiries(LoadMoreInquiries event) async* {
    try {
      yield InquiriesState.fetching(state);

      // If there are no more records to load, don't bother to request the API.
      if (!state.hasMore) {
        return;
      }

      final jwt = await SecureStore().fsc.read(key: 'jwt');

      this.apiClient.jwtToken = jwt;

      // Calculate the number to offset to skip when fetching the next page.
      final resp = await apiClient.fetchInquiries(
        offset: calcNextPageOffset(
          nextPage: state.currentPage + 1,
          perPage: event.perPage,
        ),
      );

      // if response status is not OK, emit fail event
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Normalize response with inquiry model
      final dataMap = json.decode(resp.body);
      final newInquiries = dataMap['inquiries']
          .map<Inquiry>((data) => Inquiry.fromJson(data))
          .toList();

      final appended = <Inquiry>[
        ...state.inquiries,
        ...?newInquiries,
      ].toList();

      yield InquiriesState.fetched(
        state,
        inquiries: appended,
        currentPage: state.currentPage + 1,
        hasMore: dataMap['has_more'],
        inquiryStreamMap: _createInquirySubscriptionStreamMap(appended),
      );
    } on APIException catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: e,
      );
    } catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<InquiriesState> _mapUpdateInquiryStatusToState(
      UpdateInquiryStatus event) async* {
    // Iterate through current inquiries try to find the one that matches
    // the `uuid`. Update it's status.
    final updatedInquiries = state.inquiries.map<Inquiry>((inquiry) {
      // If matches in uuid, update it's inquiry status.
      if (inquiry.uuid == event.inquiryUuid) {
        developer.log(
            'Inquiry found: ${event.inquiryUuid}, updating status: ${event.inquiryStatus.toString()}');

        return inquiry.copyWith(
          inquiryStatus: event.inquiryStatus,
        );
      }

      return inquiry;
    }).toList();

    // Replace current inquiry list witht updated list.
    yield InquiriesState.putInquiries(
      state,
      inquiries: updatedInquiries,
    );
  }

  Stream<InquiriesState> _mapRemoveInquiryToState(RemoveInquiry event) async* {
    // Remove inquiry subscription on firestore if the key exists.
    if (state.inquiryStreamMap.containsKey(event.inquiryUuid)) {
      developer.log('remove inqiury subscription: ${event.inquiryUuid}');

      // Stop subscribing to firestore document of that inquiry.
      state.inquiryStreamMap[event.inquiryUuid].cancel();

      state.inquiryStreamMap.remove(event.inquiryUuid);

      yield InquiriesState.putInquiryStreamMap(
        state,
        inquiryStreamMap: state.inquiryStreamMap,
      );
    }

    final filteredInquiries = state.inquiries
        .where((inquiry) => inquiry.uuid != event.inquiryUuid)
        .toList();

    yield InquiriesState.putInquiries(
      state,
      inquiries: filteredInquiries,
    );
  }

  Map<String, StreamSubscription<DocumentSnapshot>>
      _createInquirySubscriptionStreamMap(List<Inquiry> inquiries) {
    Map<String, StreamSubscription<DocumentSnapshot>> _streamMap = {};

    inquiries.forEach(
      (iq) {
        if (iq.inquiryStatus == InquiryStatus.asking) {
          _streamMap[iq.uuid] = _createInquirySubscriptionStream(iq.uuid);
        }
      },
    );

    return _streamMap;
  }

  StreamSubscription<DocumentSnapshot> _createInquirySubscriptionStream(
      String inquiryUuid) {
    return FirebaseFirestore.instance
        .collection('inquiries')
        .doc(inquiryUuid)
        .snapshots()
        .listen(
      (DocumentSnapshot snapshot) {
        // If male user alter the inquiry to either `canceled` or `chatting`, We need to update
        // the inquiry status in the app to reflect on the screen.
        _handleInquiryStatusChange(inquiryUuid, snapshot);
      },
    );
  }

  _handleInquiryStatusChange(String inquiryUuid, DocumentSnapshot snapshot) {
    String iqStatus = snapshot['status'] as String;

    developer.log(
        'firestore inquiry changes recieved: ${snapshot.data().toString()}');

    add(
      UpdateInquiryStatus(
        inquiryUuid: inquiryUuid,
        inquiryStatus: iqStatus.toInquiryStatusEnum(),
      ),
    );
  }

  Stream<InquiriesState> _mapAddInquirySubscriptionToState(
      AddInquirySubscription event) async* {
    developer.log('add inquiry subscription ${event.uuid}');

    final streamSub = _createInquirySubscriptionStream(event.uuid);
    state.inquiryStreamMap[event.uuid] = streamSub;

    yield InquiriesState.putInquiryStreamMap(
      state,
      inquiryStreamMap: state.inquiryStreamMap,
    );
  }
}
