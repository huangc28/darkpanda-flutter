part of 'cancel_inquiry_bloc.dart';

abstract class CancelInquiryEvent extends Equatable {
  const CancelInquiryEvent();

  @override
  List<Object> get props => [];
}

class CancelInquiry extends CancelInquiryEvent {
  const CancelInquiry(this.inquiryUuid);

  final String inquiryUuid;

  @override
  List<Object> get props => [this.inquiryUuid];
}
