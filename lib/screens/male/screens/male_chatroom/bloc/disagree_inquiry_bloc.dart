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

part 'disagree_inquiry_event.dart';
part 'disagree_inquiry_state.dart';

class DisagreeInquiryBloc
    extends Bloc<DisagreeInquiryEvent, DisagreeInquiryState> {
  DisagreeInquiryBloc({
    this.searchInquiryAPIs,
  }) : super(DisagreeInquiryState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<DisagreeInquiryState> mapEventToState(
    DisagreeInquiryEvent event,
  ) async* {
    if (event is DisagreeInquiry) {
      yield* _mapDisagressInquiryFormToState(event);
    }
  }

  Stream<DisagreeInquiryState> _mapDisagressInquiryFormToState(
      DisagreeInquiry event) async* {
    try {
      yield DisagreeInquiryState.loading(state);

      final resp = await searchInquiryAPIs.disagreeInquiry(event.channelUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield DisagreeInquiryState.done(state);
    } on APIException catch (e) {
      yield DisagreeInquiryState.error(e);
    } catch (e) {
      yield DisagreeInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
