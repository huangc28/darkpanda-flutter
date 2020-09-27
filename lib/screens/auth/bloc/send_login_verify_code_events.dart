part of 'send_login_verify_code_bloc.dart';

abstract class SendLoginVerifyCodeEvent extends Equatable {
  const SendLoginVerifyCodeEvent();

  @override
  List<Object> get props => [];
}

class SendLoginVerifyCode extends SendLoginVerifyCodeEvent {
  final String username;

  const SendLoginVerifyCode({this.username});
}
