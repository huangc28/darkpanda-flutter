import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/pkg/secure_store.dart';

import '../services/auth_api_client.dart';

part 'send_login_verify_code_events.dart';
part 'send_login_verify_code_state.dart';

class SendLoginVerifyCodeBloc
    extends Bloc<SendLoginVerifyCodeEvent, SendLoginVerifyCodeState> {
  SendLoginVerifyCodeBloc({this.authApiClient})
      : assert(authApiClient != null),
        super(SendLoginVerifyCodeState.initial());

  final AuthAPIClient authApiClient;

  @override
  Stream<SendLoginVerifyCodeState> mapEventToState(
    SendLoginVerifyCodeEvent event,
  ) async* {
    if (event is SendLoginVerifyCode) {
      yield* _mapSendLoginVerifyCodeToState(event);
    }
  }

  Stream<SendLoginVerifyCodeState> _mapSendLoginVerifyCodeToState(
      SendLoginVerifyCode event) async* {
    try {
      yield SendLoginVerifyCodeState.sending();

      // @TODO fix mocked jwt token
      // final jwt = await SecureStore().fsc.read(key: 'jwt');
      // request the API to check if the username exists. If it exists,
      // sends the login verify code. If there is a problem, display or
      // log the error.
      final resp = await authApiClient.sendLoginVerifyCode(event.username);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final authMap = json.decode(resp.body);

      yield SendLoginVerifyCodeState.sendSuccess(
        state,
        verifyChar: authMap['verify_prefix'],
        uuid: authMap['uuid'],
        mobile: authMap['mobile'],
      );
    } on APIException catch (e) {
      print('DEBUG APIException 1 ${e.message}');

      yield SendLoginVerifyCodeState.sendFailed(
        error: e,
      );
    } on AppGeneralExeption catch (e) {
      print('DEBUG APIException 2 ~~ ${e.message}');
    } catch (e) {
      print('DEBUG APIException 3 ~~ ${e.toString()}');
    }
  }
}
