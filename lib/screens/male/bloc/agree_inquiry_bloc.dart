import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'agree_inquiry_event.dart';
part 'agree_inquiry_state.dart';

class AgreeInquiryBloc extends Bloc<AgreeInquiryEvent, AgreeInquiryState> {
  AgreeInquiryBloc({
    this.searchInquiryAPIs,
  }) : super(AgreeInquiryState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<AgreeInquiryState> mapEventToState(
    AgreeInquiryEvent event,
  ) async* {
    if (event is AgreeInquiry) {
      yield* _mapSubmitSearchInquiryFormToState(event);
    }
  }

  Stream<AgreeInquiryState> _mapSubmitSearchInquiryFormToState(
      AgreeInquiry event) async* {
    try {
      yield AgreeInquiryState.loading();

      final resp = await searchInquiryAPIs.agreeInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield AgreeInquiryState.done();
    } on APIException catch (e) {
      yield AgreeInquiryState.error(e);
    } catch (e) {
      yield AgreeInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
