import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../services/api_client.dart';
import '../../../models/inquiry.dart';

part 'inquiries_event.dart';
part 'inquiries_state.dart';

class InquiriesBloc extends Bloc<InquiriesEvent, InquiriesState> {
  final ApiClient apiClient;

  InquiriesBloc({this.apiClient}) : super(InquiriesState.initial());

  @override
  Stream<InquiriesState> mapEventToState(
    InquiriesEvent event,
  ) async* {
    if (event is FetchInquiries) {}
    yield* _mapFetchInquiriesToState(event);
  }

  Stream<InquiriesState> _mapFetchInquiriesToState(
      FetchInquiries event) async* {
    try {
      // @TODO fix mocked jwt token
      // final jwt = await SecureStore().fsc.read(key: 'jwt');

      this.apiClient.jwtToken =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMmM4MDhjNDEtYWI5OS00ODE3LWE0MzYtYjI5YzJhNjVmNWVhIiwiYXV0aG9yaXplZCI6ZmFsc2UsImV4cCI6MTYwMDYyODY5NX0.1moLhvp_MfgxMbwwd2gp0aNo1F0NE8S2B2vUO84lESg";
      final resp = await apiClient.fetchInquiries(offset: 0);

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
      );

      print('DEBUG ~~~');
    } on APIException catch (e) {
      print('DEBUG 2 ${e.message}');
      yield InquiriesState.fetchFailed(
        state,
        error: e,
      );
    } catch (e) {
      print('DEBUG 2 $e');
      yield InquiriesState.fetchFailed(
        state,
        error: AppGeneralExeption(
          message: e.toString(),
        ),
      );
    }
  }
}
