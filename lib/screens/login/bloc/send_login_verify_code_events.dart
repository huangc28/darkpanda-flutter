part of 'send_login_verify_code_bloc.dart';

abstract class SendLoginVerifyCodeEvent extends Equatable {
  const SendLoginVerifyCodeEvent();

  @override
  List<Object> get props => [];
}

class SendLoginVerifyCode extends SendLoginVerifyCodeEvent {
  final String username;
  final String password;

  const SendLoginVerifyCode({
    this.username,
    this.password,
  });
}

class SendLoginVerifyCodeResetNumSend extends SendLoginVerifyCodeEvent {
  final String username;
  final String password;

  const SendLoginVerifyCodeResetNumSend({
    this.username,
    this.password,
  });
}
