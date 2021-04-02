part of 'pickup_inquiry_bloc.dart';

class PickupInquiryState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;

  PickupInquiryState._({
    this.status,
    this.error,
  });

  PickupInquiryState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  PickupInquiryState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  PickupInquiryState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  PickupInquiryState.loaded()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
