import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/apis.dart';

part 'verify_bank_event.dart';
part 'verify_bank_state.dart';

class VerifyBankBloc extends Bloc<VerifyBankEvent, VerifyBankState> {
  VerifyBankBloc({
    this.bankAPIClient,
  })  : assert(bankAPIClient != null),
        super(VerifyBankState.initial());

  final BankAPIClient bankAPIClient;

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

      final resp = await bankAPIClient.verifyBankAccount(
        event.uuid,
        event.bankName,
        event.branch,
        event.accoutNumber,
      );

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      yield VerifyBankState.done();
    } on APIException catch (e) {
      print('DEBUG err 1 ${e}');
      yield VerifyBankState.error(e);
    } catch (e) {
      yield VerifyBankState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
