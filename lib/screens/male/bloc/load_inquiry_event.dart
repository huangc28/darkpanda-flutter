part of 'load_inquiry_bloc.dart';

abstract class LoadInquiryEvent extends Equatable {
  const LoadInquiryEvent();

  @override
  List<Object> get props => [];
}

class LoadInquiry extends LoadInquiryEvent {
  const LoadInquiry();
}

class ClearLoadInquiryState extends LoadInquiryEvent {
  const ClearLoadInquiryState();
}

class UpdateLoadInquiryStatus extends LoadInquiryEvent {
  final String inquiryUuid;
  final InquiryStatus inquiryStatus;

  const UpdateLoadInquiryStatus({
    this.inquiryUuid,
    this.inquiryStatus,
  });
}

class AddLoadInquirySubscription extends LoadInquiryEvent {
  final String uuid;

  const AddLoadInquirySubscription({
    this.uuid,
  });
}
