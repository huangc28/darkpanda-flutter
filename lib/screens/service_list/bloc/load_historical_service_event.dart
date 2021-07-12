part of 'load_historical_service_bloc.dart';

abstract class LoadHistoricalServiceEvent extends Equatable {
  const LoadHistoricalServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadHistoricalService extends LoadHistoricalServiceEvent {
  final int perPage;
  final int nextPage;

  const LoadHistoricalService({
    this.perPage = 5,
    this.nextPage = 1,
  }) : assert(nextPage > 0);
}

class LoadMoreHistoricalService extends LoadHistoricalServiceEvent {
  final int perPage;

  const LoadMoreHistoricalService({
    this.perPage = 5,
  });
}

class ClearHistoricalServiceState extends LoadHistoricalServiceEvent {
  const ClearHistoricalServiceState();
}
