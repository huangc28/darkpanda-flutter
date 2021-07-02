import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/change_mobile_apis.dart';

part 'verify_change_mobile_event.dart';
part 'verify_change_mobile_state.dart';

class VerifyChangeMobileBloc
    extends Bloc<VerifyChangeMobileEvent, VerifyChangeMobileState> {
  VerifyChangeMobileBloc({
    this.changeMobileClient,
  }) : super(VerifyChangeMobileState.initial());

  final ChangeMobileClient changeMobileClient;

  @override
  Stream<VerifyChangeMobileState> mapEventToState(
    VerifyChangeMobileEvent event,
  ) async* {
    if (event is VerifyChangeMobile) {
      yield* _mapVerifyBankToState(event);
    }
  }

  Stream<VerifyChangeMobileState> _mapVerifyBankToState(
      VerifyChangeMobile event) async* {
    try {
      yield VerifyChangeMobileState.loading();

      final resp =
          await changeMobileClient.verifyChangeMobile(event.verifyCode);

      // if response status is not equal to 200, throw an exception.
      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      yield VerifyChangeMobileState.done();
    } on APIException catch (e) {
      yield VerifyChangeMobileState.error(e);
    } catch (e) {
      yield VerifyChangeMobileState.error(
          new AppGeneralExeption(message: e.toString()));
    }
  }
}
