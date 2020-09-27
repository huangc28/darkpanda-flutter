import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';

part 'send_login_verify_code_events.dart';
part 'send_login_verify_code_state.dart';

class SendLoginVerifyCodeBloc
    extends Bloc<SendLoginVerifyCodeEvent, SendLoginVerifyCodeState> {
  SendLoginVerifyCodeBloc() : super(SendLoginVerifyCodeState.initial());

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
      // request the API to check if the username exists. If it exists,
      // sends the login verify code. If there is a problem, display or
      // log the error.
      print('DEBUG trigger send login verify code');
      yield SendLoginVerifyCodeState.sendSuccess(state, jwt: 'somejwt');
    } on APIException catch (e) {
      print('DEBUG APIException 1 ${e.message}');
      // yield SendLoginVerifyCodeState.sendFailed(
      //   error: APIException.fromJson(data);

      // );
    } catch (e) {
      print('DEBUG APIException 2 ${e.toString()}');
    }
  }
}
