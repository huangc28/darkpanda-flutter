part of 'pickup_inquiry_bloc.dart';

class PickupInquiryState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;

  /// This map keeps track of inquiry record on firestore document. The app would
  /// react state change on the inquiry made by female or male user.
  final Map<String, StreamSubscription> inquiryStreamMap;

  PickupInquiryState._({
    this.status,
    this.error,
    this.inquiryStreamMap,
  });

  PickupInquiryState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
          inquiryStreamMap: {},
        );

  PickupInquiryState.loading(PickupInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  PickupInquiryState.loadFailed(
    PickupInquiryState state, {
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error ?? state.error,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  PickupInquiryState.loaded(
    PickupInquiryState state, {
    Map<String, StreamSubscription> inquiryStreamMap,
  }) : this._(
          status: AsyncLoadingStatus.done,
          error: state.error,
          inquiryStreamMap: inquiryStreamMap ?? state.inquiryStreamMap,
        );

  @override
  List<Object> get props => [
        status,
        error,
        inquiryStreamMap,
      ];
}
