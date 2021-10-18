import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/create_inquiry_response.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/models/inquiry_forms.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

part 'direct_inquiry_form_event.dart';
part 'direct_inquiry_form_state.dart';

class DirectInquiryFormBloc
    extends Bloc<DirectInquiryFormEvent, DirectInquiryFormState> {
  DirectInquiryFormBloc({
    this.searchInquiryAPIs,
    // this.loadInquiryBloc,
  })  : assert(searchInquiryAPIs != null),
        // assert(loadInquiryBloc != null),
        super(DirectInquiryFormState.initial());

  final SearchInquiryAPIs searchInquiryAPIs;
  // final LoadInquiryBloc loadInquiryBloc;

  @override
  Stream<DirectInquiryFormState> mapEventToState(
    DirectInquiryFormEvent event,
  ) async* {
    if (event is SubmitDirectInquiryForm) {
      yield* _mapSubmitDirectInquiryFormToState(event);
    }
  }

  Stream<DirectInquiryFormState> _mapSubmitDirectInquiryFormToState(
      SubmitDirectInquiryForm event) async* {
    try {
      yield DirectInquiryFormState.loading(state);

      final resp = await searchInquiryAPIs.directInquiry(
        event.inquiryForms,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      CreateInquiryResponse createInquiryResponse =
          CreateInquiryResponse.fromMap(
        json.decode(resp.body),
      );

      yield DirectInquiryFormState.done(
        state,
        createInquiryResponse: createInquiryResponse,
      );
    } on APIException catch (err) {
      yield DirectInquiryFormState.error(state, err: err);
    } catch (e) {
      yield DirectInquiryFormState.error(state,
          err: new AppGeneralExeption(message: e.toString()));
    }
  }
}
