import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/pkg/fibonacci.dart';

import '../services/data_provider.dart';
import '../models/models.dart' as models;

part 'send_sms_code_event.dart';
part 'send_sms_code_state.dart';

class SendSmsCodeBloc extends Bloc<SendSmsCodeEvent, SendSmsCodeState> {
  final PhoneVerifyDataProvider dataProvider;
  final TimerBloc timerBloc;

  SendSmsCodeBloc({
    @required this.dataProvider,
    @required this.timerBloc,
  }) : super(SendSmsCodeState.initial(0));

  @override
  Stream<SendSmsCodeState> mapEventToState(
    SendSmsCodeEvent event,
  ) async* {
    if (event is SendSMSCode) {
      try {
        yield SendSmsCodeState.sending(
          SendSmsCodeState.copyFrom(state),
        );

        final resp = await dataProvider.sendVerifyCode(
          countryCode: event.countryCode,
          mobileNumber: event.mobileNumber,
          uuid: event.uuid,
        );

        if (resp.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(resp.body));
        }

        final currNumSend = state.numSend;
        final parsedResp = models.SendSMS.fromJson(json.decode(resp.body));

        // convert response to model
        yield SendSmsCodeState.sendSuccess(SendSmsCodeState.copyFrom(
          state,
          sendSMS: parsedResp,
          numSend: state.numSend + 1,
        ));

        // If user intends to resend for more than 2 times, we start locking
        // the resend button for a fixed time range.
        if (currNumSend > 1) {
          timerBloc.add(StartTimer(
            duration: Fib.genFib(currNumSend) * Duration.secondsPerMinute,
          ));
        }
      } on APIException catch (e) {
        yield SendSmsCodeState.sendFailed(SendSmsCodeState.copyFrom(
          state,
          error: e,
        ));
      } catch (e) {
        yield SendSmsCodeState.sendFailed(
          SendSmsCodeState.copyFrom(
            state,
            error: AppGeneralExeption(message: e.toString()),
          ),
        );
      }
    }
  }
}
