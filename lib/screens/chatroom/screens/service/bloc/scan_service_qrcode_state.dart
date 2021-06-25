part of 'scan_service_qrcode_bloc.dart';

class ScanServiceQrCodeState<E extends AppBaseException> extends Equatable {
  const ScanServiceQrCodeState._({
    this.status,
    this.serviceQrCode,
    this.error,
  });

  final AsyncLoadingStatus status;

  final ServiceQrCode serviceQrCode;

  final E error;

  const ScanServiceQrCodeState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const ScanServiceQrCodeState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const ScanServiceQrCodeState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const ScanServiceQrCodeState.loaded({
    ServiceQrCode serviceQrCode,
  }) : this._(
          status: AsyncLoadingStatus.done,
          serviceQrCode: serviceQrCode,
        );

  const ScanServiceQrCodeState.clearState()
      : this._(
          serviceQrCode: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
        error,
        serviceQrCode,
      ];
}
