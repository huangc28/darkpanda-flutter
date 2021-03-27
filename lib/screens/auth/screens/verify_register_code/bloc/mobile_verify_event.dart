part of 'mobile_verify_bloc.dart';

abstract class MobileVerifyEvent extends Equatable {
  const MobileVerifyEvent();

  @override
  List<Object> get props => [];
}

class VerifyMobile extends MobileVerifyEvent {
  final String verifyChars;
  final String verifyDigs;
  final String uuid;
  final String mobileNumber;

  VerifyMobile({
    this.verifyChars,
    this.verifyDigs,
    this.uuid,
    this.mobileNumber,
  });
}
