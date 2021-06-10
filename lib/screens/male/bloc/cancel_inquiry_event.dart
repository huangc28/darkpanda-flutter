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

class SkipInquiry extends CancelInquiryEvent {
  const SkipInquiry(this.inquiryUuid);

  final String inquiryUuid;

  @override
  List<Object> get props => [this.inquiryUuid];
}

class QuitChatroom extends CancelInquiryEvent {
  const QuitChatroom(this.channelUuid);

  final String channelUuid;

  @override
  List<Object> get props => [this.channelUuid];
}

class DisagreeInquiry extends CancelInquiryEvent {
  const DisagreeInquiry(this.channelUuid);

  final String channelUuid;

  @override
  List<Object> get props => [this.channelUuid];
}
