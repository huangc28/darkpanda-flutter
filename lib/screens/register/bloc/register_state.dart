part of 'register_bloc.dart';

enum RegisterStatus {
  unknown,
  registering,
  registerFailed,
  registered,
}

class RegisterState extends Equatable {
  final RegisterStatus status;
  final Error error;
  final RegisteredUser user;

  const RegisterState._({
    this.status,
    this.error,
    this.user,
  });

  /// Bloc yields following states
  const RegisterState.unknown()
      : this._(
          status: RegisterStatus.unknown,
        );

  const RegisterState.registering()
      : this._(
          status: RegisterStatus.registering,
        );

  const RegisterState.registerFailed(Error err)
      : this._(
          status: RegisterStatus.registerFailed,
          error: err,
        );

  const RegisterState.registered(RegisteredUser user)
      : this._(
          status: RegisterStatus.registered,
          user: user,
        );

  @override
  List<Object> get props => [status, user];
}

// abstract class RegisterState extends Equatable {
//   const RegisterState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class RegisterInitial extends RegisterState {
//   const RegisterInitial();
// }
//
// class Registering extends RegisterState {
//   const Registering();
// }
//
// class RegisterFailed extends RegisterState {
//   final Error error;
//
//   const RegisterFailed({this.error});
// }
//
// class Registered extends RegisterState {
//   final RegisteredUser registeredUser;
//
//   Registered({this.registeredUser});
// }
