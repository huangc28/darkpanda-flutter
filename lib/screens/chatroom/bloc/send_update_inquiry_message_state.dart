part of 'send_update_inquiry_message_bloc.dart';

class SendUpdateInquiryMessageState<E extends AppBaseException>
    extends Equatable {
  const SendUpdateInquiryMessageState._({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;
  final E error;

  SendUpdateInquiryMessageState.init()
      : this._(status: AsyncLoadingStatus.initial);

  SendUpdateInquiryMessageState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  SendUpdateInquiryMessageState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: error,
        );

  SendUpdateInquiryMessageState.loaded()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [status];
}
