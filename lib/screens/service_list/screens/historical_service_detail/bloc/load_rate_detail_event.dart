part of 'load_rate_detail_bloc.dart';

abstract class LoadRateDetailEvent extends Equatable {
  const LoadRateDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadRateDetail extends LoadRateDetailEvent {
  const LoadRateDetail({this.serviceUuid});
  final String serviceUuid;

  @override
  List<Object> get props => [serviceUuid];
}
