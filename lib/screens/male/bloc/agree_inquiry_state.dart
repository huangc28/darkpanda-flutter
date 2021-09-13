part of 'agree_inquiry_bloc.dart';

class AgreeInquiryState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final AgreeInquiryResponse agreeInquiry;

  const AgreeInquiryState._({
    this.error,
    this.status,
    this.agreeInquiry,
  });

  /// Bloc yields following states
  AgreeInquiryState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          agreeInquiry: null,
        );

  AgreeInquiryState.loading(AgreeInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          agreeInquiry: state.agreeInquiry,
        );

  AgreeInquiryState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  AgreeInquiryState.done(
    AgreeInquiryState state, {
    AgreeInquiryResponse agreeInquiry,
  }) : this._(
          status: AsyncLoadingStatus.done,
          agreeInquiry: agreeInquiry ?? state.agreeInquiry,
        );

  @override
  List<Object> get props => [
        error,
        status,
        agreeInquiry,
      ];
}
