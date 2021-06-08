import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'load_inquiry_event.dart';
part 'load_inquiry_state.dart';

class LoadInquiryBloc extends Bloc<LoadInquiryEvent, LoadInquiryState> {
  LoadInquiryBloc({
    this.searchInquiryAPIs,
  }) : super(LoadInquiryState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<LoadInquiryState> mapEventToState(
    LoadInquiryEvent event,
  ) async* {
    if (event is LoadInquiry) {
      yield* _mapLoadInquiryEventToState(event);
    } else if (event is ClearLoadInquiryState) {
      yield* _mapClearLoadInquiryStateToState(event);
    } else if (event is UpdateLoadInquiryStatus) {
      yield* _mapUpdateLoadInquiryStatusToState(event);
    } else if (event is AddLoadInquirySubscription) {
      yield* _mapAddLoadInquirySubscriptionToState(event);
    }
  }

  Stream<LoadInquiryState> _mapLoadInquiryEventToState(
      LoadInquiry event) async* {
    try {
      // toggle loading
      yield LoadInquiryState.loading(state);

      // request API
      final res = await searchInquiryAPIs.fetchInquiry();

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final activeInquiry = ActiveInquiry.fromMap(
        json.decode(res.body),
      );

      yield LoadInquiryState.loaded(
        state,
        activeInquiry: activeInquiry,
        inquiryStreamMap: _createInquirySubscriptionStreamMap(activeInquiry),
      );
    } on APIException catch (err) {
      yield LoadInquiryState.loadFailed(
        state,
        error: err,
      );
    } catch (err) {
      yield LoadInquiryState.loadFailed(
        state,
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }

  Stream<LoadInquiryState> _mapClearLoadInquiryStateToState(
      ClearLoadInquiryState event) async* {
    yield LoadInquiryState.clearState();
  }

  Stream<LoadInquiryState> _mapUpdateLoadInquiryStatusToState(
      UpdateLoadInquiryStatus event) async* {
    // Iterate through current inquiries try to find the one that matches
    // the `uuid`. Update it's status.

    ActiveInquiry updateInquiry = new ActiveInquiry();
    if (state.activeInquiry.uuid == event.inquiryUuid) {
      developer.log(
          'Inquiry found: ${event.inquiryUuid}, updating status: ${event.inquiryStatus.toString()}');

      updateInquiry = state.activeInquiry.copyWith(
        inquiryStatus: event.inquiryStatus,
      );
    }

    // Replace current inquiry list witht updated list.
    yield LoadInquiryState.putInquiries(
      state,
      activeInquiry: updateInquiry,
    );
  }

  Map<String, StreamSubscription<DocumentSnapshot>>
      _createInquirySubscriptionStreamMap(ActiveInquiry inquiry) {
    Map<String, StreamSubscription<DocumentSnapshot>> _streamMap = {};

    if (inquiry.inquiryStatus == InquiryStatus.asking ||
        inquiry.inquiryStatus == InquiryStatus.inquiring) {
      _streamMap[inquiry.uuid] = _createInquirySubscriptionStream(inquiry.uuid);
    }

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
      UpdateLoadInquiryStatus(
        inquiryUuid: inquiryUuid,
        inquiryStatus: iqStatus.toInquiryStatusEnum(),
      ),
    );
  }

  Stream<LoadInquiryState> _mapAddLoadInquirySubscriptionToState(
      AddLoadInquirySubscription event) async* {
    developer.log('add inquiry subscription ${event.uuid}');

    final streamSub = _createInquirySubscriptionStream(event.uuid);
    state.inquiryStreamMap[event.uuid] = streamSub;

    yield LoadInquiryState.putInquiryStreamMap(
      state,
      inquiryStreamMap: state.inquiryStreamMap,
    );
  }
}
