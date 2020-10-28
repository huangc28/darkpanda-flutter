part of 'pickup_inquiry_bloc.dart';

enum PickupInquiryStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class PickupInquiryState<E extends AppBaseException> extends Equatable {
  final PickupInquiryStatus status;
  final E error;

  PickupInquiryState._({
    this.status,
    this.error,
  });

  PickupInquiryState.init()
      : this._(
          status: PickupInquiryStatus.initial,
        );

  PickupInquiryState.loading()
      : this._(
          status: PickupInquiryStatus.loading,
        );

  PickupInquiryState.loadFailed(E error)
      : this._(
          status: PickupInquiryStatus.loadFailed,
          error: error,
        );

  PickupInquiryState.loaded()
      : this._(
          status: PickupInquiryStatus.loaded,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
