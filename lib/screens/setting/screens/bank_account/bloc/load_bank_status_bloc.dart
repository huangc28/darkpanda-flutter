import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../services/apis.dart';
import '../models/bank_status_detail.dart';

part 'load_bank_status_event.dart';
part 'load_bank_status_state.dart';

class LoadBankStatusBloc
    extends Bloc<LoadBankStatusEvent, LoadBankStatusState> {
  LoadBankStatusBloc({this.apiClient})
      : assert(apiClient != null),
        super(LoadBankStatusState.initial());

  final BankAPIClient apiClient;

  @override
  Stream<LoadBankStatusState> mapEventToState(
      LoadBankStatusEvent event) async* {
    if (event is LoadBank) {
      yield* _mapLoadBankEventToState(event);
    }
  }

  Stream<LoadBankStatusState> _mapLoadBankEventToState(LoadBank event) async* {
    try {
      // toggle loading
      yield LoadBankStatusState.loading(state);

      // request API
      final jwt = await SecureStore().readJwtToken();
      apiClient.jwtToken = jwt;
      final res = await apiClient.fetchUserBankStatus(event.uuid);

      if (res.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(res.body),
        );
      }

      yield LoadBankStatusState.loaded(
        bankStatusDetail: BankStatusDetail.fromJson(
          json.decode(res.body),
        ),
      );
    } on APIException catch (err) {
      yield LoadBankStatusState.loadFailed(
        error: err,
      );
    } catch (err) {
      yield LoadBankStatusState.loadFailed(
        error: AppGeneralExeption(message: err.toString()),
      );
    }
  }
}
