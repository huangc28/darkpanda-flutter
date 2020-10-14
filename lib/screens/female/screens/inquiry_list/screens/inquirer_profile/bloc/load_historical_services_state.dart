part of 'load_historical_services_bloc.dart';

enum LoadHistoricalServicesStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class LoadHistoricalServicesState<E extends AppBaseException>
    extends Equatable {
  const LoadHistoricalServicesState._({
    this.status,
    this.historicalServices,
    this.error,
  });

  final LoadHistoricalServicesStatus status;
  final List<HistoricalService> historicalServices;
  final E error;

  LoadHistoricalServicesState.initial()
      : this._(
          status: LoadHistoricalServicesStatus.initial,
          historicalServices: [],
        );

  LoadHistoricalServicesState.loading(LoadHistoricalServicesState state)
      : this._(
          status: LoadHistoricalServicesStatus.loading,
          historicalServices: state.historicalServices,
        );

  const LoadHistoricalServicesState.loadFailed({
    E error,
  }) : this._(
          status: LoadHistoricalServicesStatus.loadFailed,
          error: error,
        );

  const LoadHistoricalServicesState.loaded({
    List<HistoricalService> historicalServices,
  }) : this._(
          status: LoadHistoricalServicesStatus.loaded,
          historicalServices: historicalServices,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
