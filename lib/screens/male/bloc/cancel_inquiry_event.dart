part of 'cancel_inquiry_bloc.dart';

abstract class CancelInquiryEvent extends Equatable {
  const CancelInquiryEvent();

  @override
  List<Object> get props => [];
}

class CancelInquiry extends CancelInquiryEvent {
  const CancelInquiry({
    this.inquiryUuid,
    this.fcmTopic,
  });

  final String inquiryUuid;
  final String fcmTopic;

  @override
  List<Object> get props => [this.inquiryUuid, this.fcmTopic];
}

class SkipInquiry extends CancelInquiryEvent {
  const SkipInquiry(this.inquiryUuid);

  final String inquiryUuid;

  @override
  List<Object> get props => [this.inquiryUuid];
}
