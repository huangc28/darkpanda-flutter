import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';

import '../data_provider.dart';
import '../models/models.dart' as models;

part 'send_sms_code_event.dart';
part 'send_sms_code_state.dart';

class SendSmsCodeBloc extends Bloc<SendSmsCodeEvent, SendSmsCodeState> {
  final PhoneVerifyDataProvider dataProvider;

  SendSmsCodeBloc({this.dataProvider}) : super(SendSmsCodeState.initial());

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

        // convert response to model
        yield SendSmsCodeState.sendSuccess(
          models.SendSMS.fromJson(json.decode(resp.body)),
        );
      } on APIException catch (e) {
        SendSmsCodeState.sendFailed(e);
      } catch (e) {
        yield SendSmsCodeState.sendFailed(
            AppGeneralExeption(message: e.toString()));
      }
    }
  }
}
