import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/services/inquiry_apis.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'update_inquiry_event.dart';
part 'update_inquiry_state.dart';

class UpdateInquiryBloc extends Bloc<UpdateInquiryEvent, UpdateInquiryState> {
  UpdateInquiryBloc({
    this.apis,
  })  : assert(apis != null),
        super(UpdateInquiryInitial());

  final InquiryAPIClient apis;

  @override
  Stream<UpdateInquiryState> mapEventToState(
    UpdateInquiryEvent event,
  ) async* {
    if (event is UpdateInquiry) {
      yield* _mapUpdateInquiryToState(event);
    }
  }

  Stream<UpdateInquiryState> _mapUpdateInquiryToState(
      UpdateInquiry event) async* {
    yield UpdateInquiryLoading();

    try {
      final resp = await apis.updateInquiry(
        event.serviceSettings,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      // Replace existing inquiry settings.
      final serviceSettings = ServiceSettings.fromMap(
        json.decode(resp.body),
      );

      yield UpdateInquiryDone(serviceSettings: serviceSettings);
    } on APIException catch (e) {
      yield UpdateInquiryError(e);
    } catch (e) {
      yield UpdateInquiryError(
        AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
