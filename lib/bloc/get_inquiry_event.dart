part of 'get_inquiry_bloc.dart';

abstract class GetInquiryEvent extends Equatable {
  const GetInquiryEvent();

  @override
  List<Object> get props => [];
}

class GetInquiry extends GetInquiryEvent {
  const GetInquiry({
    this.inquiryUuid,
  });

  final String inquiryUuid;
}
