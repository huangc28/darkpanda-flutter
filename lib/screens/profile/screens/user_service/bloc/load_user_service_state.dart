part of 'load_user_service_bloc.dart';

class LoadUserServiceState<E extends AppBaseException> extends Equatable {
  const LoadUserServiceState._({
    this.status,
    this.userRatings,
    this.error,
  });

  final AsyncLoadingStatus status;

  final UserRatings userRatings;

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
    UserRatings userRatings,
  }) : this._(
          status: AsyncLoadingStatus.done,
          userRatings: userRatings,
        );

  const LoadUserServiceState.clearState()
      : this._(
          userRatings: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
