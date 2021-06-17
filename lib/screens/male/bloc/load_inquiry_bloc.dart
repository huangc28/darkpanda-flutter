import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
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
    this.loadUserBloc,
  }) : super(LoadInquiryState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final LoadUserBloc loadUserBloc;

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
    } else if (event is RemoveLoadInquiry) {
      yield* _mapRemoveLoadInquiryToState(event);
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

      // if (activeInquiry.inquiryStatus)

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
    // To find the one that matches
    // the `uuid`. Update it's status.

    ActiveInquiry updateInquiry = new ActiveInquiry();
    if (state.activeInquiry.uuid == event.inquiryUuid) {
      developer.log(
          'Inquiry found: ${event.inquiryUuid}, updating status: ${event.inquiryStatus.toString()}');

      updateInquiry = state.activeInquiry.copyWith(
        inquiryStatus: event.inquiryStatus,
        pickerUuid: event.pickerUuid,
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

    if (inquiry.inquiryStatus == InquiryStatus.inquiring ||
        inquiry.inquiryStatus == InquiryStatus.asking) {
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
    String iqPickerUuid = "";

    if (iqStatus == InquiryStatus.asking.name) {
      iqPickerUuid = snapshot['picker_uuid'] as String;
      loadUserBloc.add(LoadUser(uuid: iqPickerUuid));
    }

    developer.log(
        'firestore inquiry changes recieved: ${snapshot.data().toString()}');

    add(
      UpdateLoadInquiryStatus(
        inquiryUuid: inquiryUuid,
        inquiryStatus: iqStatus.toInquiryStatusEnum(),
        pickerUuid: iqPickerUuid,
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

  Stream<LoadInquiryState> _mapRemoveLoadInquiryToState(
      RemoveLoadInquiry event) async* {
    // Remove inquiry subscription on firestore if the key exists.
    if (state.inquiryStreamMap.containsKey(event.inquiryUuid)) {
      developer.log('remove inqiury subscription: ${event.inquiryUuid}');

      // Stop subscribing to firestore document of that inquiry.
      state.inquiryStreamMap[event.inquiryUuid].cancel();

      state.inquiryStreamMap.remove(event.inquiryUuid);

      yield LoadInquiryState.putInquiryStreamMap(
        state,
        inquiryStreamMap: state.inquiryStreamMap,
      );
    }

    ActiveInquiry updateInquiry = new ActiveInquiry();

    yield LoadInquiryState.putInquiries(
      state,
      activeInquiry: updateInquiry,
    );
  }
}
