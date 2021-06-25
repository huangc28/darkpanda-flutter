part of 'scan_service_qrcode_bloc.dart';

abstract class ScanServiceQrCodeEvent extends Equatable {
  const ScanServiceQrCodeEvent();

  @override
  List<Object> get props => [];
}

class ScanServiceQrCode extends ScanServiceQrCodeEvent {
  final ScanQrCode scanQrCode;

  const ScanServiceQrCode({this.scanQrCode});
}

class ClearServiceQrCodeState extends ScanServiceQrCodeEvent {
  const ClearServiceQrCodeState();
}
