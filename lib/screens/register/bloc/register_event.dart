part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class Register extends RegisterEvent {
  final String username;
  final String gender;
  final String referalcode;

  Register({
    this.username,
    this.gender,
    this.referalcode,
  });
}
