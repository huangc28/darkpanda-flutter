import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../services/api_client.dart';
import '../bloc/picked_inquiries_dart_bloc.dart';
import '../../../models/picked_inquiry.dart';

part 'pickup_inquiry_event.dart';
part 'pickup_inquiry_state.dart';

class PickupInquiryBloc extends Bloc<PickupInquiryEvent, PickupInquiryState> {
  PickupInquiryBloc({
    this.apiClient,
    this.pickedInquiriesBloc,
  })  : assert(apiClient != null),
        assert(pickedInquiriesBloc != null),
        super(PickupInquiryState.init());

  final ApiClient apiClient;
  final PickedInquiriesDartBloc pickedInquiriesBloc;

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

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      final pi = PickedInquiry.fromMap(
        json.decode(
          res.body,
        ),
      );

      // Picked inquiry should be placed in PickedInquiries Bloc.
      pickedInquiriesBloc.add(
        AddPickedInqiury(
          pickedInquiry: pi,
        ),
      );
    } on APIException catch (err) {
      yield PickupInquiryState.loadFailed(err);
    } on AppGeneralExeption catch (err) {
      yield PickupInquiryState.loadFailed(err);
    } on Error catch (err) {
      yield PickupInquiryState.loadFailed(
        AppGeneralExeption(
          message: err.toString(),
        ),
      );
    }
  }
}
