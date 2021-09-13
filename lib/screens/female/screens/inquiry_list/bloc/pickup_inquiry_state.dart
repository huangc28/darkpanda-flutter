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

  PickupInquiryState.loading(PickupInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  PickupInquiryState.loadFailed(
    PickupInquiryState state, {
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error ?? state.error,
        );

  PickupInquiryState.loaded(
    PickupInquiryState state,
  ) : this._(
          status: AsyncLoadingStatus.done,
          error: state.error,
        );

  PickupInquiryState.putInquiryStreamMap(
    PickupInquiryState state,
  ) : this._(
          status: state.status,
          error: state.error,
        );

  @override
  List<Object> get props => [
        status,
        error,
      ];
}
