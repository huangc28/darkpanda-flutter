part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class Registering extends RegisterState {
  const Registering();
}

class RegisterFailed extends RegisterState {
  final String message;
  final String code;

  const RegisterFailed({this.message, this.code});
}

// class Registered extends RegisterState {
//   Register _register;

//   Registered(this._register) : super();
// }
