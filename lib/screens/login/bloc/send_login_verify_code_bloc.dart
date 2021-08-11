import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';

import 'package:darkpanda_flutter/pkg/fibonacci.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import '../services/login_api_client.dart';

part 'send_login_verify_code_events.dart';
part 'send_login_verify_code_state.dart';

class SendLoginVerifyCodeBloc
    extends Bloc<SendLoginVerifyCodeEvent, SendLoginVerifyCodeState> {
  SendLoginVerifyCodeBloc({
    this.authApiClient,
    this.timerBloc,
  })  : assert(authApiClient != null),
        assert(timerBloc != null),
        super(SendLoginVerifyCodeState.initial(0));

  final LoginAPIClient authApiClient;
  final TimerBloc timerBloc;

  @override
  Stream<SendLoginVerifyCodeState> mapEventToState(
    SendLoginVerifyCodeEvent event,
  ) async* {
    if (event is SendLoginVerifyCode) {
      yield* _mapSendLoginVerifyCodeToState(event);
    } else if (event is SendLoginVerifyCodeResetNumSend) {
      yield* _mapSendLoginVerifyCodeResetNumSendToState(event);
    }
  }

  Stream<SendLoginVerifyCodeState> _mapSendLoginVerifyCodeResetNumSendToState(
      SendLoginVerifyCodeResetNumSend event) async* {
    yield SendLoginVerifyCodeState.resetNumSend(
      SendLoginVerifyCodeState.copyFrom(state),
    );

    add(
      SendLoginVerifyCode(username: event.username),
    );
  }

  Stream<SendLoginVerifyCodeState> _mapSendLoginVerifyCodeToState(
      SendLoginVerifyCode event) async* {
    try {
      yield SendLoginVerifyCodeState.sending(
        SendLoginVerifyCodeState.copyFrom(state),
      );

      // Request the API to check if the username exists. If it exists,
      // sends the login verify code. If there is a problem, display or
      // log the error.
      final resp = await authApiClient.sendLoginVerifyCode(event.username);

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(
          json.decode(resp.body),
        );
      }

      final authMap = json.decode(resp.body);
      final currNumSend = state.numSend;

      yield SendLoginVerifyCodeState.sendSuccess(
        SendLoginVerifyCodeState.copyFrom(
          state,
          verifyChar: authMap['verify_prefix'],
          uuid: authMap['uuid'],
          mobile: authMap['mobile'],
          numSend: currNumSend + 1,
        ),
      );

      // If user intends to send login verify code more than 1 times, we generate
      // cooldown countdown to throttle the resend.
      if (currNumSend > 0) {
        timerBloc.add(
          StartTimer(
            duration: Fib.genFib(currNumSend) * Duration.secondsPerMinute,
          ),
        );
      }
    } on APIException catch (e) {
      yield SendLoginVerifyCodeState.sendFailed(
        SendLoginVerifyCodeState.copyFrom(state, error: e),
      );
    } on Exception catch (e) {
      yield SendLoginVerifyCodeState.sendFailed(
        SendLoginVerifyCodeState.copyFrom(state, error: e),
      );
    }
  }
}
