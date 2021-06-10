part of 'cancel_inquiry_bloc.dart';

class CancelInquiryState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const CancelInquiryState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const CancelInquiryState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const CancelInquiryState.loading(CancelInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const CancelInquiryState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const CancelInquiryState.done(CancelInquiryState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
