part of 'load_historical_service_bloc.dart';

class LoadHistoricalServiceState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final List<HistoricalService> services;
  final E error;
  // final bool hasMore;
  final int currentPage;

  const LoadHistoricalServiceState._({
    this.status,
    this.services,
    this.error,
    // this.hasMore,
    this.currentPage,
  });

  LoadHistoricalServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          services: [],
          // hasMore: true,
          currentPage: 0,
        );

  LoadHistoricalServiceState.loading(LoadHistoricalServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          services: state.services,
          // hasMore: state.hasMore,
          currentPage: state.currentPage,
        );

  LoadHistoricalServiceState.loadFailed(
    LoadHistoricalServiceState state, {
    E err,
  }) : this._(
          status: AsyncLoadingStatus.error,
          services: state.services,
          error: err ?? state.error,
          // hasMore: state.hasMore,
          currentPage: state.currentPage,
        );

  LoadHistoricalServiceState.loadSuccess(
    LoadHistoricalServiceState state, {
    List<HistoricalService> services,
    int currentPage,
    // bool hasMore,
  }) : this._(
          status: AsyncLoadingStatus.done,
          services: services ?? state.services,
          // hasMore: hasMore ?? state.hasMore,
          currentPage: currentPage ?? state.currentPage,
        );

  LoadHistoricalServiceState.clearState(LoadHistoricalServiceState state)
      : this._(
          services: [],
          status: AsyncLoadingStatus.initial,
          // hasMore: true,
          currentPage: 0,
        );

  @override
  List<Object> get props => [
        status,
        services,
        error,
        // hasMore,
        currentPage,
      ];
}
