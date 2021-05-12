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
    this.userRating,
    this.error,
  });

  final AsyncLoadingStatus status;

  final UserRating userRating;

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
    UserRating userRating,
  }) : this._(
          status: AsyncLoadingStatus.done,
          userRating: userRating,
        );

  const LoadRateState.clearState()
      : this._(
          userRating: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
