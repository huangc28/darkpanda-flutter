import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/screens/bloc/timer_bloc.dart';

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
    print('DEBUG 3');
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

        // convert response to model
        yield SendSmsCodeState.sendSuccess(
          models.SendSMS.fromJson(json.decode(resp.body)),
          state.numSend + 1,
        );

        // start resend lock timer
        timerBloc.add(StartTimer(duration: 1));
      } on APIException catch (e) {
        print('DEBUG 1 ${e.toString()}');
        SendSmsCodeState.sendFailed(e);
      } catch (e) {
        print('DEBUG 2 ${e.toString()}');
        yield SendSmsCodeState.sendFailed(
            AppGeneralExeption(message: e.toString()));
      }
    }
  }
}
