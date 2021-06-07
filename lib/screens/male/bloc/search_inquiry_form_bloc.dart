import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
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
  }) : super(SearchInquiryFormState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;

  @override
  Stream<SearchInquiryFormState> mapEventToState(
    SearchInquiryFormEvent event,
  ) async* {
    if (event is SubmitSearchInquiryForm) {
      yield* _mapSubmitSearchInquiryFormToState(event);
    }
  }

  Stream<SearchInquiryFormState> _mapSubmitSearchInquiryFormToState(
      SubmitSearchInquiryForm event) async* {
    try {
      yield SearchInquiryFormState.loading();

      final resp = await searchInquiryAPIs.searchInquiry(
        event.inquiryForms,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(
            resp.body,
          ),
        );
      }

      yield SearchInquiryFormState.done();
    } on APIException catch (e) {
      yield SearchInquiryFormState.error(e);
    } catch (e) {
      yield SearchInquiryFormState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
