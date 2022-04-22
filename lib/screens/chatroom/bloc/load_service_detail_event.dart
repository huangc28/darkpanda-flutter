part of 'load_service_detail_bloc.dart';

abstract class LoadServiceDetailEvent extends Equatable {
  const LoadServiceDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadServiceDetail extends LoadServiceDetailEvent {
  final String serviceUuid;

  const LoadServiceDetail({this.serviceUuid});
}

class ClearServiceDetailState extends LoadServiceDetailEvent {
  const ClearServiceDetailState();
}
