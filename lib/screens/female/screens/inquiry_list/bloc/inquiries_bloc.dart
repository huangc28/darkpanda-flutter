import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../util/util.dart';
import '../services/api_client.dart';
import '../../../models/inquiry.dart';

part 'inquiries_event.dart';
part 'inquiries_state.dart';

class InquiriesBloc extends Bloc<InquiriesEvent, InquiriesState> {
  final ApiClient apiClient;

  /// @TODO mocked api token, should be removed.
  final String mockedApiToken;

  InquiriesBloc({
    this.apiClient,
    this.mockedApiToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMmM4MDhjNDEtYWI5OS00ODE3LWE0MzYtYjI5YzJhNjVmNWVhIiwiYXV0aG9yaXplZCI6ZmFsc2UsImV4cCI6MTYwMDgwNTY1NH0.q6enlJb8Zwr9bHwurIQqK5aW4IPAW8I1WYMEMzqm8no',
  }) : super(InquiriesState.initial());

  @override
  Stream<InquiriesState> mapEventToState(
    InquiriesEvent event,
  ) async* {
    if (event is FetchInquiries) {
      yield* _mapFetchInquiriesToState(event);
    }

    if (event is AppendInquiries) {
      yield* _mapAppendInquiriesToState(event);
    }
  }

  Stream<InquiriesState> _mapFetchInquiriesToState(
      FetchInquiries event) async* {
    try {
      yield InquiriesState.fetching(state);
      // @TODO fix mocked jwt token
      // final jwt = await SecureStore().fsc.read(key: 'jwt');

      this.apiClient.jwtToken = mockedApiToken;
      final resp = await apiClient.fetchInquiries(
        offset: calcNextPageOffset(
          nextPage: event.nextPage,
          perPage: event.perPage,
        ),
      );

      // if response status is not OK, emit fail event
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      // Normalize response with inquiry model
      final dataMap = json.decode(resp.body);

      yield InquiriesState.fetched(
        state,
        inquiries: dataMap['inquiries']
            .map<Inquiry>((data) => Inquiry.fromJson(data))
            .toList(),

        /// this event always fetch the first page
        currentPage: event.nextPage,
      );
    } on APIException catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: e,
      );
    } catch (e) {
      yield InquiriesState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }

  Stream<InquiriesState> _mapAppendInquiriesToState(
      AppendInquiries event) async* {
    print('DEBUG _mapAppendInquiriesToState ${event.inquiries}');
    final appended = <Inquiry>[
      ...state.inquiries,
      ...?event.inquiries,
    ].toList();

    // Append fetched inquiry onto existing inquiry.
    yield InquiriesState.fetched(
      state,
      inquiries: appended,
    );
  }
}
