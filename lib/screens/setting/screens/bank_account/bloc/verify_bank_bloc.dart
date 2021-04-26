import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';
import '../models/bank.dart';

part 'verify_bank_event.dart';
part 'verify_bank_state.dart';

class VerifyBankBloc extends Bloc<VerifyBankEvent, VerifyBankState> {
  VerifyBankBloc({
    this.apiClient,
  }) : super(VerifyBankState.initial());

  final BankAPIClient apiClient;

  @override
  Stream<VerifyBankState> mapEventToState(
    VerifyBankEvent event,
  ) async* {
    if (event is VerifyBank) {
      yield* _mapVerifyBankToState(event);
    }
  }

  Stream<VerifyBankState> _mapVerifyBankToState(VerifyBank event) async* {
    try {
      yield VerifyBankState.loading();

      final resp = await apiClient.verifyBankAccount(
        uuid: event.uuid,
        accountName: event.accountName,
        bankCode: event.bankCode,
        accountNumber: event.accoutNumber,
      );

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      yield VerifyBankState.done(
        Bank.fromJson(
          json.decode(resp.body),
        ),
      );
    } on APIException catch (e) {
      yield VerifyBankState.error(e);
    } catch (e) {
      yield VerifyBankState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
