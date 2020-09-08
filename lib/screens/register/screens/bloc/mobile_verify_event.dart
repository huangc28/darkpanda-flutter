part of 'mobile_verify_bloc.dart';

abstract class MobileVerifyEvent extends Equatable {
  const MobileVerifyEvent();

  @override
  List<Object> get props => [];
}

class SendSMSCode extends MobileVerifyEvent {
  final String countryCode;
  final String mobileNumber;
  final String uuid;

  SendSMSCode({
    this.countryCode,
    this.mobileNumber,
    this.uuid,
  });
}
