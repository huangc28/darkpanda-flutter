part of 'load_cancel_service_bloc.dart';

abstract class LoadCancelServiceEvent extends Equatable {
  const LoadCancelServiceEvent();

  @override
  List<Object> get props => [];
}

class LoadCancelService extends LoadCancelServiceEvent {
  final String serviceUuid;

  const LoadCancelService({this.serviceUuid});
}
