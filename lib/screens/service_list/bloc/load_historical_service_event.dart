part of 'load_historical_service_bloc.dart';

abstract class LoadHistoricalServiceEvent extends Equatable {
  const LoadHistoricalServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadHistoricalService extends LoadHistoricalServiceEvent {
  const LoadHistoricalService();
}

class ClearHistoricalServiceState extends LoadHistoricalServiceEvent {
  const ClearHistoricalServiceState();
}
