import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'cancel_inquiry_event.dart';
part 'cancel_inquiry_state.dart';

class CancelInquiryBloc extends Bloc<CancelInquiryEvent, CancelInquiryState> {
  CancelInquiryBloc({
    this.searchInquiryAPIs,
    this.loadInquiryBloc,
  }) : super(CancelInquiryState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final LoadInquiryBloc loadInquiryBloc;

  @override
  Stream<CancelInquiryState> mapEventToState(
    CancelInquiryEvent event,
  ) async* {
    if (event is CancelInquiry) {
      yield* _mapCancelInquiryFormToState(event);
    } else if (event is SkipInquiry) {
      yield* _mapSkipInquiryFormToState(event);
    }
  }

  Stream<CancelInquiryState> _mapCancelInquiryFormToState(
      CancelInquiry event) async* {
    try {
      yield CancelInquiryState.loading(state);

      final resp = await searchInquiryAPIs.cancelInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      loadInquiryBloc.add(
        RemoveLoadInquiry(inquiryUuid: event.inquiryUuid),
      );

      yield CancelInquiryState.done(state);
    } on APIException catch (e) {
      yield CancelInquiryState.error(e);
    } catch (e) {
      yield CancelInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }

  Stream<CancelInquiryState> _mapSkipInquiryFormToState(
      SkipInquiry event) async* {
    try {
      yield CancelInquiryState.loading(state);

      final resp = await searchInquiryAPIs.skipInquiry(event.inquiryUuid);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield CancelInquiryState.done(state);
    } on APIException catch (e) {
      yield CancelInquiryState.error(e);
    } catch (e) {
      yield CancelInquiryState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
