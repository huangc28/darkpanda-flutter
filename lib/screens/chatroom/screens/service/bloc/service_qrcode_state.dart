part of 'service_qrcode_bloc.dart';

class ServiceQrCodeState<E extends AppBaseException> extends Equatable {
  const ServiceQrCodeState._({
    this.status,
    this.serviceQrCode,
    this.error,
  });

  final AsyncLoadingStatus status;

  final ServiceQrCode serviceQrCode;

  final E error;

  const ServiceQrCodeState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const ServiceQrCodeState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const ServiceQrCodeState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const ServiceQrCodeState.loaded({
    ServiceQrCode serviceQrCode,
  }) : this._(
          status: AsyncLoadingStatus.done,
          serviceQrCode: serviceQrCode,
        );

  const ServiceQrCodeState.clearState()
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
