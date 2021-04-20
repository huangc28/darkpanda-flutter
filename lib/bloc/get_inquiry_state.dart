part of 'get_inquiry_bloc.dart';

class GetInquiryState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;
  final Inquiry inquiry;

  const GetInquiryState._({
    this.status,
    this.error,
    this.inquiry,
  });

  GetInquiryState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  GetInquiryState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  GetInquiryState.error(E error)
      : this._(status: AsyncLoadingStatus.error, error: error);

  GetInquiryState.done(Inquiry inquiry)
      : this._(
          status: AsyncLoadingStatus.done,
          inquiry: inquiry,
        );

  @override
  List<Object> get props => [
        status,
        error,
        inquiry,
      ];
}
