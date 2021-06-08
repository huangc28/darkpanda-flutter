part of 'agree_inquiry_bloc.dart';

abstract class AgreeInquiryEvent extends Equatable {
  const AgreeInquiryEvent();

  @override
  List<Object> get props => [];
}

class AgreeInquiry extends AgreeInquiryEvent {
  const AgreeInquiry(this.inquiryUuid);

  final String inquiryUuid;

  @override
  List<Object> get props => [this.inquiryUuid];
}
