import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../models/verify_bank.dart';
import '../models/verify_bank.dart' as models;
import '../services/apis.dart';

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
    if (event is UpdateVerifyBank) {
      yield* _mapVerifyBankToState(event, state);
    } else if (event is AccountNameChanged) {
      yield _mapUpdateAccountNameToState(event, state);
    } else if (event is BankCodeChanged) {
      yield _mapBankCodeChangedToState(event, state);
    } else if (event is AccoutNumberChanged) {
      yield _mapAccoutNumberChangedToState(event, state);
    }
  }

  Stream<VerifyBankState> _mapVerifyBankToState(
      UpdateVerifyBank event, VerifyBankState state) async* {
    try {
      yield VerifyBankState.loading(
        VerifyBankState.copyFrom(state),
      );

      VerifyBank verifyBank = new VerifyBank();
      verifyBank = await getVerifyBank(state);

      await apiClient.verifyBankAccount(verifyBank);

      yield VerifyBankState.done();
    } on APIException catch (e) {
      yield VerifyBankState.error(
        VerifyBankState.copyFrom(
          state,
          error: e,
        ),
      );
    } catch (e) {
      yield VerifyBankState.error(
        VerifyBankState.copyFrom(
          state,
          error: AppGeneralExeption(message: e.toString()),
        ),
      );
    }
  }

  VerifyBankState _mapUpdateAccountNameToState(
    AccountNameChanged event,
    VerifyBankState state,
  ) {
    final accountName = event.accountName;

    return state.copyWith(
      accountName: accountName,
    );
  }

  VerifyBankState _mapBankCodeChangedToState(
    BankCodeChanged event,
    VerifyBankState state,
  ) {
    final bankCode = event.bankCode;

    return state.copyWith(
      accountName: bankCode,
    );
  }

  VerifyBankState _mapAccoutNumberChangedToState(
    AccoutNumberChanged event,
    VerifyBankState state,
  ) {
    final accoutNumber = event.accoutNumber;

    return state.copyWith(
      accoutNumber: accoutNumber,
    );
  }

  Future<VerifyBank> getVerifyBank(VerifyBankState state) async {
    VerifyBank verifyBank;

    verifyBank = new VerifyBank(
      uuid: state.uuid,
      accountName: state.accountName,
      bankCode: state.bankCode,
      accoutNumber: state.accoutNumber,
    );

    return verifyBank;
  }
}
