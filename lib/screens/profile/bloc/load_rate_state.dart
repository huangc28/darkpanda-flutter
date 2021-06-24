part of 'load_rate_bloc.dart';

enum LoadRateStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class LoadRateState<E extends AppBaseException> extends Equatable {
  const LoadRateState._({
    this.status,
    this.userRatings,
    this.error,
  });

  final AsyncLoadingStatus status;

  final UserRatings userRatings;

  final E error;

  const LoadRateState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const LoadRateState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const LoadRateState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadRateState.loaded({
    UserRatings userRatings,
  }) : this._(
          status: AsyncLoadingStatus.done,
          userRatings: userRatings,
        );

  const LoadRateState.clearState()
      : this._(
          userRatings: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
