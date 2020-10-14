part of 'load_historical_services_bloc.dart';

abstract class LoadHistoricalServicesEvent extends Equatable {
  const LoadHistoricalServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadHistoricalServices extends LoadHistoricalServicesEvent {
  const LoadHistoricalServices({
    this.uuid,
    this.offset = 0,
  });

  final String uuid;
  final int offset;
}
