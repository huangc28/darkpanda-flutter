part of 'send_sms_code_bloc.dart';

abstract class SendSmsCodeEvent extends Equatable {
  const SendSmsCodeEvent();

  @override
  List<Object> get props => [];
}

class SendSMSCode extends SendSmsCodeEvent {
  final String countryCode;
  final String mobileNumber;
  final String uuid;

  SendSMSCode({
    this.countryCode,
    this.mobileNumber,
    this.uuid,
  });
}
