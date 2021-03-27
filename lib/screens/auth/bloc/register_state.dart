part of 'register_bloc.dart';

enum RegisterStatus {
  unknown,
  registering,
  registerFailed,
  registered,
}

class RegisterState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;
  final RegisteredUser user;

  const RegisterState._({
    this.status,
    this.error,
    this.user,
  });

  /// Bloc yields following states
  const RegisterState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const RegisterState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const RegisterState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const RegisterState.done(RegisteredUser user)
      : this._(
          status: AsyncLoadingStatus.done,
          user: user,
        );

  @override
  List<Object> get props => [
        status,
        user,
      ];
}
