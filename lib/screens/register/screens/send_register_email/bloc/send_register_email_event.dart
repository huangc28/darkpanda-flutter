part of 'send_register_email_bloc.dart';

abstract class SendRegisterEmailEvent extends Equatable {
  const SendRegisterEmailEvent();

  @override
  List<Object> get props => [];
}

class SendRegister extends SendRegisterEmailEvent {
  final String email;
  final String username;
  final String password;

  SendRegister({
    this.email,
    this.username,
    this.password,
  });
}
