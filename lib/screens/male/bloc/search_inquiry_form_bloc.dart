import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/models/inquiry_forms.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'search_inquiry_form_event.dart';
part 'search_inquiry_form_state.dart';

class SearchInquiryFormBloc
    extends Bloc<SearchInquiryFormEvent, SearchInquiryFormState> {
  SearchInquiryFormBloc({
    this.searchInquiryAPIs,
    this.loadInquiryBloc,
  })  : assert(searchInquiryAPIs != null),
        assert(loadInquiryBloc != null),
        super(SearchInquiryFormState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  final LoadInquiryBloc loadInquiryBloc;

  @override
  Stream<SearchInquiryFormState> mapEventToState(
    SearchInquiryFormEvent event,
  ) async* {
    if (event is SubmitSearchInquiryForm) {
      yield* _mapSubmitSearchInquiryFormToState(event);
    } else if (event is SubmitEditSearchInquiryForm) {
      yield* _mapSubmitEditSearchInquiryFormToState(event);
    }
  }

  Stream<SearchInquiryFormState> _mapSubmitSearchInquiryFormToState(
      SubmitSearchInquiryForm event) async* {
    try {
      yield SearchInquiryFormState.loading(state);

      final resp = await searchInquiryAPIs.searchInquiry(
        event.inquiryForms,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      yield SearchInquiryFormState.done();
    } on APIException catch (err) {
      yield SearchInquiryFormState.error(state, err: err);
    } catch (e) {
      yield SearchInquiryFormState.error(state,
          err: new AppGeneralExeption(message: e.toString()));
    }
  }

  Stream<SearchInquiryFormState> _mapSubmitEditSearchInquiryFormToState(
      SubmitEditSearchInquiryForm event) async* {
    try {
      yield SearchInquiryFormState.loading(state);

      final resp = await searchInquiryAPIs.updateInquiry(
        event.inquiryForms,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      yield SearchInquiryFormState.done();
    } on APIException catch (err) {
      yield SearchInquiryFormState.error(state, err: err);
    } catch (e) {
      yield SearchInquiryFormState.error(state,
          err: new AppGeneralExeption(message: e.toString()));
    }
  }
}
