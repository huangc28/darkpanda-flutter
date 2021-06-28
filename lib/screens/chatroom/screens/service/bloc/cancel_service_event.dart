part of 'cancel_service_bloc.dart';

abstract class CancelServiceEvent extends Equatable {
  const CancelServiceEvent();

  @override
  List<Object> get props => [];
}

class CancelService extends CancelServiceEvent {
  final String serviceUuid;

  const CancelService({this.serviceUuid});
}

class ClearServiceQrCodeState extends CancelServiceEvent {
  const ClearServiceQrCodeState();
}
