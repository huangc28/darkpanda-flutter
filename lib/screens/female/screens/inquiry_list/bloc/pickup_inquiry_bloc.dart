import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';

import './inquiries_bloc.dart';
import '../services/api_client.dart';

// import '../../../models/picked_inquiry.dart';

part 'pickup_inquiry_event.dart';
part 'pickup_inquiry_state.dart';

class PickupInquiryBloc extends Bloc<PickupInquiryEvent, PickupInquiryState> {
  PickupInquiryBloc({
    this.apiClient,
    // this.inquiryChatroomsBloc,
    this.inquiriesBloc,
  })  : assert(apiClient != null),
        assert(inquiriesBloc != null),
        // assert(inquiryChatroomsBloc != null),
        super(PickupInquiryState.init());

  final ApiClient apiClient;
  // final InquiryChatroomsBloc inquiryChatroomsBloc;
  final InquiriesBloc inquiriesBloc;

  @override
  Stream<PickupInquiryState> mapEventToState(
    PickupInquiryEvent event,
  ) async* {
    if (event is PickupInquiry) {
      yield* _mapPickupInquiryToState(event);
    }
  }

  Stream<PickupInquiryState> _mapPickupInquiryToState(
      PickupInquiry event) async* {
    try {
      yield PickupInquiryState.loading();

      final res = await apiClient.pickupInquiry(event.uuid);

      print('DEBUG pickup iq resp ${res.body} ${res.statusCode}');

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      // This female user is now waiting for inquirers to reply .
      // Update the status of corresponding inqiury in the app
      // to reflect on the screen.
      final dataMap = json.decode(res.body);

      print('DEBUG dataMap ${dataMap}');

      String iqStatus = dataMap['inquiry_status'] as String;

      inquiriesBloc.add(
        UpdateInquiryStatus(
          inquiryUuid: event.uuid,
          inquiryStatus: iqStatus.toInquiryStatusEnum(),
        ),
      );

      // We need to listen to that inquiry record document

      PickupInquiryState.loaded();
    } on APIException catch (err) {
      yield PickupInquiryState.loadFailed(err);
    } on AppGeneralExeption catch (err) {
      yield PickupInquiryState.loadFailed(err);
    } on Exception catch (err) {
      yield PickupInquiryState.loadFailed(
        AppGeneralExeption(
          message: err.toString(),
        ),
      );
    }
  }
}
