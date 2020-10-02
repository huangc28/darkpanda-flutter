part of 'register_bloc.dart';

enum RegisterStatus {
  unknown,
  registering,
  registerFailed,
  registered,
}

class RegisterState<E extends AppBaseException> extends Equatable {
  final RegisterStatus status;
  final E error;
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

  const RegisterState.registerFailed(E err)
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
