import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';

import './inquiries_bloc.dart';
import '../services/api_client.dart';

part 'pickup_inquiry_event.dart';
part 'pickup_inquiry_state.dart';

class PickupInquiryBloc extends Bloc<PickupInquiryEvent, PickupInquiryState> {
  PickupInquiryBloc({
    this.apiClient,
    this.inquiriesBloc,
  })  : assert(apiClient != null),
        assert(inquiriesBloc != null),
        super(PickupInquiryState.init());

  final ApiClient apiClient;
  final InquiriesBloc inquiriesBloc;

  @override
  Stream<PickupInquiryState> mapEventToState(
    PickupInquiryEvent event,
  ) async* {
    if (event is PickupInquiry) {
      yield* _mapPickupInquiryToState(event);
    }
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

    inquiriesBloc.add(
      UpdateInquiryStatus(
        inquiryUuid: inquiryUuid,
        inquiryStatus: iqStatus.toInquiryStatusEnum(),
      ),
    );
  }

  Stream<PickupInquiryState> _mapPickupInquiryToState(
      PickupInquiry event) async* {
    try {
      yield PickupInquiryState.loading(state);

      final res = await apiClient.pickupInquiry(event.uuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      // This female user is now waiting for inquirers to reply .
      // Update the status of corresponding inqiury in the app
      // to reflect on the screen.
      final dataMap = json.decode(res.body);

      String iqStatus = dataMap['inquiry_status'] as String;

      inquiriesBloc.add(
        UpdateInquiryStatus(
          inquiryUuid: event.uuid,
          inquiryStatus: iqStatus.toInquiryStatusEnum(),
        ),
      );

      // We need to listen to that inquiry record document on firestore. The inquiry has to react to
      // status change on firestore made by male user.
      // We will achieve this by keeping a map of `inquiry_uuid: StreamSubscription`.

      final streamSub = _createInquirySubscriptionStream(event.uuid);
      state.inquiryStreamMap[event.uuid] = streamSub;

      PickupInquiryState.loaded(
        state,
        inquiryStreamMap: state.inquiryStreamMap,
      );
    } on APIException catch (err) {
      yield PickupInquiryState.loadFailed(
        state,
        error: err,
      );
    } on AppGeneralExeption catch (err) {
      yield PickupInquiryState.loadFailed(
        state,
        error: err,
      );
    } on Exception catch (err) {
      yield PickupInquiryState.loadFailed(
        state,
        error: AppGeneralExeption(
          message: err.toString(),
        ),
      );
    }
  }
}
