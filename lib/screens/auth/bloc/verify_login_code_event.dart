part of 'verify_login_code_bloc.dart';

abstract class VerifyLoginCodeEvent extends Equatable {
  const VerifyLoginCodeEvent();

  @override
  List<Object> get props => [];
}

class SendVerifyLoginCode extends VerifyLoginCodeEvent {
  const SendVerifyLoginCode({
    this.mobile,
    this.uuid,
    this.verifyChars,
    this.verifyDigs,
  });

  final String mobile;
  final String uuid;
  final String verifyChars;
  final String verifyDigs;
}
