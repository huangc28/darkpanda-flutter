import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/screens/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/screens/pkg/fibonacci.dart';

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
  }) : super(SendSmsCodeState.initial());

  @override
  Stream<SendSmsCodeState> mapEventToState(
    SendSmsCodeEvent event,
  ) async* {
    if (event is SendSMSCode) {
      try {
        yield SendSmsCodeState.sending();

        final resp = await dataProvider.sendVerifyCode(
          countryCode: event.countryCode,
          mobileNumber: event.mobileNumber,
          uuid: event.uuid,
        );

        if (resp.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(resp.body));
        }

        final currNumSend = state.numSend;

        // convert response to model
        yield SendSmsCodeState.sendSuccess(
          models.SendSMS.fromJson(json.decode(resp.body)),
          state.numSend + 1,
        );

        if (currNumSend > 0) {
          final nextWaitDuration = Fib.genFib(currNumSend);
          timerBloc.add(StartTimer(
            duration: nextWaitDuration * Duration.secondsPerMinute,
          ));
        }
      } on APIException catch (e) {
        yield SendSmsCodeState.sendFailed(e);
      } catch (e) {
        yield SendSmsCodeState.sendFailed(
            AppGeneralExeption(message: e.toString()));
      }
    }
  }
}
