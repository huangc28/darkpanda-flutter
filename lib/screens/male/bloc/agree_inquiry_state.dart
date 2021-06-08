part of 'agree_inquiry_bloc.dart';

class AgreeInquiryState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const AgreeInquiryState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const AgreeInquiryState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const AgreeInquiryState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const AgreeInquiryState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const AgreeInquiryState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
