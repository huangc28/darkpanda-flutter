part of 'disagree_inquiry_bloc.dart';

abstract class DisagreeInquiryEvent extends Equatable {
  const DisagreeInquiryEvent();

  @override
  List<Object> get props => [];
}

class DisagreeInquiry extends DisagreeInquiryEvent {
  const DisagreeInquiry(this.channelUuid);

  final String channelUuid;

  @override
  List<Object> get props => [this.channelUuid];
}
