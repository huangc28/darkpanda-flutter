part of 'logout_bloc.dart';

abstract class LogoutState<E extends AppBaseException> extends Equatable {
  const LogoutState({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;
  final E error;

  @override
  List<Object> get props => [status];
}

class LogoutInitial extends LogoutState {
  LogoutInitial() : super(status: AsyncLoadingStatus.initial);
}

class LoggingOut extends LogoutState {
  LoggingOut({
    AsyncLoadingStatus status,
  }) : super(status: AsyncLoadingStatus.loading);
}

class LoggedOut extends LogoutState {
  LoggedOut({
    AsyncLoadingStatus status,
  }) : super(status: AsyncLoadingStatus.done);
}

class LoggedFailed<E extends AppBaseException> extends LogoutState {
  LoggedFailed({
    E err,
  }) : super(
          status: AsyncLoadingStatus.error,
          error: err,
        );
}
