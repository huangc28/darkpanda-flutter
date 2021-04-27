import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/services/inquiry_apis.dart';
import 'package:darkpanda_flutter/models/inquiry.dart';
import 'package:darkpanda_flutter/models/service_settings.dart';

part 'get_inquiry_event.dart';
part 'get_inquiry_state.dart';

class GetInquiryBloc extends Bloc<GetInquiryEvent, GetInquiryState> {
  GetInquiryBloc({
    this.inquiryApi,
  })  : assert(inquiryApi != null),
        super(GetInquiryState.init());

  final InquiryAPIClient inquiryApi;

  @override
  Stream<GetInquiryState> mapEventToState(
    GetInquiryEvent event,
  ) async* {
    if (event is GetInquiry) {
      yield* _mapGetInquiryToState(event);
    }
  }

  Stream<GetInquiryState> _mapGetInquiryToState(GetInquiry event) async* {
    yield GetInquiryState.loading();

    try {
      final resp = await inquiryApi.getInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      developer.log('Get inquiry result ${resp.body}');

      final serviceSettings = ServiceSettings.fromMap(
        json.decode(resp.body),
      );

      yield GetInquiryState.done(serviceSettings);
    } on APIException catch (e) {
      yield GetInquiryState.error(e);
    } catch (e) {
      yield GetInquiryState.error(AppGeneralExeption(message: e.toString()));
    }
  }
}
