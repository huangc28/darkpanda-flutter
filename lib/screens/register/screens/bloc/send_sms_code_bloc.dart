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
        print('DEBUG trigger SendSmsCodeBloc');

        yield SendSmsCodeState.sending();

        final resp = await dataProvider.sendVerifyCode(
          countryCode: event.countryCode,
          mobileNumber: event.mobileNumber,
          uuid: event.uuid,
        );

        print('DEBUG trigger SendSmsCodeBloc ${resp.body}');

        if (resp.statusCode != HttpStatus.ok) {
          throw APIException.fromJson(json.decode(resp.body));
        }

        // convert response to model
        yield SendSmsCodeState.sendSuccess(
          models.SendSMS.fromJson(json.decode(resp.body)),
        );
      } on APIException catch (e) {
        print('DEBUG trigger 2 ${e.toString()}');
        SendSmsCodeState.sendFailed(e);
      } catch (e) {
        print('DEBUG trigger 3 ${e.toString()}');
        yield SendSmsCodeState.sendFailed(
            AppGeneralExeption(message: e.toString()));
      }
    }
  }
}
