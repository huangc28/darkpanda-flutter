part of 'disagree_inquiry_bloc.dart';

class DisagreeInquiryState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const DisagreeInquiryState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const DisagreeInquiryState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const DisagreeInquiryState.loading(DisagreeInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const DisagreeInquiryState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const DisagreeInquiryState.done(DisagreeInquiryState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
