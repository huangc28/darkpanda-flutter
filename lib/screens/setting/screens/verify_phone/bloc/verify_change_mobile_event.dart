part of 'verify_change_mobile_bloc.dart';

abstract class VerifyChangeMobileEvent extends Equatable {
  const VerifyChangeMobileEvent();

  @override
  List<Object> get props => [];
}

class VerifyChangeMobile extends VerifyChangeMobileEvent {
  const VerifyChangeMobile(this.verifyCode);

  final String verifyCode;

  @override
  List<Object> get props => [verifyCode];
}
