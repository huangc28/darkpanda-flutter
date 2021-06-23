part of 'service_qrcode_bloc.dart';

abstract class ServiceQrCodeEvent extends Equatable {
  const ServiceQrCodeEvent();

  @override
  List<Object> get props => [];
}

class LoadServiceQrCode extends ServiceQrCodeEvent {
  final String serviceUuid;

  const LoadServiceQrCode({this.serviceUuid});
}

class ScanServiceQrCode extends ServiceQrCodeEvent {
  final ScanQrCode scanQrCode;

  const ScanServiceQrCode({this.scanQrCode});
}

class ClearServiceQrCodeState extends ServiceQrCodeEvent {
  const ClearServiceQrCodeState();
}
