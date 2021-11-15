part of 'load_user_service_bloc.dart';

class LoadUserServiceState<E extends AppBaseException> extends Equatable {
  const LoadUserServiceState._({
    this.status,
    this.userServiceListResponse,
    this.error,
  });

  final AsyncLoadingStatus status;

  final UserServiceListResponse userServiceListResponse;

  final E error;

  const LoadUserServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const LoadUserServiceState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const LoadUserServiceState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadUserServiceState.loaded({
    UserServiceListResponse userServiceListResponse,
  }) : this._(
          status: AsyncLoadingStatus.done,
          userServiceListResponse: userServiceListResponse,
        );

  const LoadUserServiceState.clearState()
      : this._(
          userServiceListResponse: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
