part of 'load_rate_bloc.dart';

abstract class LoadRateEvent extends Equatable {
  const LoadRateEvent();

  @override
  List<Object> get props => [];
}

class LoadRate extends LoadRateEvent {
  final String uuid;

  const LoadRate({this.uuid});
}

class ClearRateState extends LoadRateEvent {
  const ClearRateState();
}
