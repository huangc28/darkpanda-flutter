import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/models/direct_inquiry_requests.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/services/inquiry_chat_list_api_client.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/util/util.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'load_direct_inquiry_request_event.dart';
part 'load_direct_inquiry_request_state.dart';

class LoadDirectInquiryRequestBloc
    extends Bloc<LoadDirectInquiryRequestEvent, LoadDirectInquiryRequestState> {
  LoadDirectInquiryRequestBloc({
    this.inquiryChatListApiClient,
  }) : super(LoadDirectInquiryRequestState.initial());

  final InquiryChatListApiClient inquiryChatListApiClient;

  @override
  Stream<LoadDirectInquiryRequestState> mapEventToState(
    LoadDirectInquiryRequestEvent event,
  ) async* {
    if (event is FetchDirectInquiries) {
      yield* _mapFetchInquiriesToState(event);
    }

    if (event is LoadMorehDirectInquiries) {
      yield* _mapLoadMoreInquiries(event);
    }

    if (event is UpdateInquiryStatus) {
      yield* _mapUpdateInquiryStatusToState(event);
    }

    if (event is RemoveInquiry) {
      yield* _mapRemoveInquiryToState(event);
    }
  }

  Stream<LoadDirectInquiryRequestState> _mapFetchInquiriesToState(
      FetchDirectInquiries event) async* {
    try {
      yield LoadDirectInquiryRequestState.fetching(state);
      yield LoadDirectInquiryRequestState.initial();

      final offset = calcNextPageOffset(
        nextPage: event.nextPage,
        perPage: event.perPage,
      );

      final resp = await inquiryChatListApiClient.fetchDirectInquiryRequest(
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

      final parsedIqs = dataMap['inquiry_requests']
          .map<DirectInquiryRequests>(
              (data) => DirectInquiryRequests.fromJson(data))
          .toList();

      yield LoadDirectInquiryRequestState.fetched(
        state,
        inquiries: parsedIqs,
        currentPage: event.nextPage,
        // We need to subscribe those inquiry with status `asking`. Organize an inquiry subscription map here.
        inquiryStreamMap: _createInquirySubscriptionStreamMap(parsedIqs),
      );
    } on APIException catch (e) {
      yield LoadDirectInquiryRequestState.fetchFailed(
        state,
        error: e,
      );
    } catch (e) {
      yield LoadDirectInquiryRequestState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.message,
        ),
      );
    }
  }

  Stream<LoadDirectInquiryRequestState> _mapLoadMoreInquiries(
      LoadMorehDirectInquiries event) async* {
    try {
      // If there are no more records to load, don't bother to request the API.
      if (!state.hasMore) {
        return;
      }

      final offset = calcNextPageOffset(
        nextPage: state.currentPage + 1,
        perPage: event.perPage,
      );

      // Calculate the number to offset to skip when fetching the next page.
      final resp = await inquiryChatListApiClient.fetchDirectInquiryRequest(
        offset: offset,
      );

      // if response status is not OK, emit fail event
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Normalize response with inquiry model
      final dataMap = json.decode(resp.body);
      final newInquiries = dataMap['inquiry_requests']
          .map<DirectInquiryRequests>(
              (data) => DirectInquiryRequests.fromJson(data))
          .toList();

      final appended = <DirectInquiryRequests>[
        ...state.inquiries,
        ...?newInquiries,
      ].toList();

      yield LoadDirectInquiryRequestState.fetched(
        state,
        inquiries: appended,
        currentPage: state.currentPage + 1,
        // hasMore: dataMap['has_more'],
        inquiryStreamMap: _createInquirySubscriptionStreamMap(appended),
      );
    } on APIException catch (e) {
      yield LoadDirectInquiryRequestState.fetchFailed(
        state,
        error: e,
      );
    } catch (e) {
      yield LoadDirectInquiryRequestState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<LoadDirectInquiryRequestState> _mapUpdateInquiryStatusToState(
      UpdateInquiryStatus event) async* {
    // Iterate through current inquiries try to find the one that matches
    // the `uuid`. Update it's status.
    final updatedInquiries =
        state.inquiries.map<DirectInquiryRequests>((inquiry) {
      // If matches in uuid, update it's inquiry status.
      if (inquiry.inquiryUuid == event.inquiryUuid) {
        developer.log(
            'Inquiry found: ${event.inquiryUuid}, updating status: ${event.inquiryStatus.toString()}');

        return inquiry.copyWith(
          inquiryStatus: event.inquiryStatus,
          // channelUuid: event.channelUuid,
          // serviceUUID: event.serviceUuid,
        );
      }

      return inquiry;
    }).toList();

    // Replace current inquiry list witht updated list.
    yield LoadDirectInquiryRequestState.putInquiries(
      state,
      inquiries: updatedInquiries,
    );
  }

  Stream<LoadDirectInquiryRequestState> _mapRemoveInquiryToState(
      RemoveInquiry event) async* {
    // Remove inquiry subscription on firestore if the key exists.
    if (state.inquiryStreamMap.containsKey(event.inquiryUuid)) {
      developer.log('remove inqiury subscription: ${event.inquiryUuid}');

      // Stop subscribing to firestore document of that inquiry.
      state.inquiryStreamMap[event.inquiryUuid].cancel();

      state.inquiryStreamMap.remove(event.inquiryUuid);

      yield LoadDirectInquiryRequestState.putInquiryStreamMap(
        state,
        inquiryStreamMap: state.inquiryStreamMap,
      );
    }

    final filteredInquiries = state.inquiries
        .where((inquiry) => inquiry.inquiryUuid != event.inquiryUuid)
        .toList();

    yield LoadDirectInquiryRequestState.putInquiries(
      state,
      inquiries: filteredInquiries,
    );
  }

  Map<String, StreamSubscription<DocumentSnapshot>>
      _createInquirySubscriptionStreamMap(
          List<DirectInquiryRequests> inquiries) {
    Map<String, StreamSubscription<DocumentSnapshot>> _streamMap = {};

    inquiries.forEach(
      (iq) {
        if (iq.inquiryStatus == InquiryStatus.asking) {
          _streamMap[iq.inquiryUuid] =
              _createInquirySubscriptionStream(iq.inquiryUuid);
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
    print('DEBUG trigger _handleInquiryStatusChange');
    // String iqStatus = snapshot['status'] as String;
    // String channelUuid = snapshot['channel_uuid'] as String;
    // String serviceUuid = snapshot['service_uuid'] as String;

    // developer.log(
    //     'firestore inquiry changes recieved: ${snapshot.data().toString()}');

    // add(
    //   UpdateInquiryStatus(
    //     inquiryUuid: inquiryUuid,
    //     inquiryStatus: iqStatus.toInquiryStatusEnum(),
    //     channelUuid: channelUuid,
    //     serviceUuid: serviceUuid,
    //   ),
    // );
  }
}
