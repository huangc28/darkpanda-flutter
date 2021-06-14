part of 'load_historical_service_bloc.dart';

class LoadHistoricalServiceState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final List<HistoricalService> services;
  final E error;

  const LoadHistoricalServiceState._({
    this.status,
    this.services,
    this.error,
  });

  LoadHistoricalServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          services: [],
        );

  LoadHistoricalServiceState.loading(LoadHistoricalServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          services: [],
        );

  LoadHistoricalServiceState.loadFailed(LoadHistoricalServiceState state, E err)
      : this._(
          status: AsyncLoadingStatus.error,
        );

  LoadHistoricalServiceState.loadSuccess(
    LoadHistoricalServiceState state, {
    List<HistoricalService> services,
    Map<String, StreamSubscription> privateChatStreamMap,
  }) : this._(
          services: services ?? state.services,
          status: AsyncLoadingStatus.done,
        );

  LoadHistoricalServiceState.clearState(LoadHistoricalServiceState state)
      : this._(
          services: [],
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
        services,
        error,
      ];
}
