import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/pkg/fibonacci.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/register/screens/send_register_email/services/send_register_api_client.dart';

part 'send_register_email_event.dart';
part 'send_register_email_state.dart';

class SendRegisterEmailBloc
    extends Bloc<SendRegisterEmailEvent, SendRegisterEmailState> {
  SendRegisterEmailBloc({
    @required this.sendRegisterApiClient,
    @required this.timerBloc,
  }) : super(SendRegisterEmailState.initial(0));

  final SendRegisterApiClient sendRegisterApiClient;
  final TimerBloc timerBloc;

  @override
  Stream<SendRegisterEmailState> mapEventToState(
    SendRegisterEmailEvent event,
  ) async* {
    if (event is SendRegister) {
      yield* _mapSendSMSCodeToState(event);
    }
  }

  Stream<SendRegisterEmailState> _mapSendSMSCodeToState(
      SendRegister event) async* {
    try {
      yield SendRegisterEmailState.sending(
        SendRegisterEmailState.copyFrom(state),
      );

      final resp = await sendRegisterApiClient.sendRegisterEmail(
        email: event.email,
        username: event.username,
        password: event.password,
      );

      if (resp.statusCode != HttpStatus.ok) {
        throw APIException.fromJson(json.decode(resp.body));
      }

      final currNumSend = state.numSend;
      // final parsedResp = SendSMS.fromJson(json.decode(resp.body));

      // convert response to model
      yield SendRegisterEmailState.sendSuccess(
        SendRegisterEmailState.copyFrom(
          state,
          // sendSMS: parsedResp,
          numSend: currNumSend + 1,
        ),
      );

      // If user intends to resend for more than 2 times, we start locking
      // the resend button for a fixed time range.
      timerBloc.add(
        StartTimer(
          duration: Fib.genFib(currNumSend) * Duration.secondsPerMinute,
        ),
      );
    } on APIException catch (e) {
      yield SendRegisterEmailState.sendFailed(SendRegisterEmailState.copyFrom(
        state,
        error: e,
      ));
    } catch (e) {
      yield SendRegisterEmailState.sendFailed(
        SendRegisterEmailState.copyFrom(
          state,
          error: AppGeneralExeption(message: e.toString()),
        ),
      );
    }
  }
}
