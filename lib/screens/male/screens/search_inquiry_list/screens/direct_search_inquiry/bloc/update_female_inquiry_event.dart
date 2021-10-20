part of 'update_female_inquiry_bloc.dart';

abstract class UpdateFemaleInquiryEvent extends Equatable {
  const UpdateFemaleInquiryEvent();

  @override
  List<Object> get props => [];
}

class UpdateInquiryStatus extends UpdateFemaleInquiryEvent {
  final String inquiryUuid;
  final String channelUuid;
  final String serviceUuid;
  final InquiryStatus inquiryStatus;

  const UpdateInquiryStatus({
    this.inquiryUuid,
    this.channelUuid,
    this.serviceUuid,
    this.inquiryStatus,
  });
}

class ClearFemaleListState extends UpdateFemaleInquiryEvent {
  const ClearFemaleListState();
}

class UpdateFemaleInquiry extends UpdateFemaleInquiryEvent {
  const UpdateFemaleInquiry({
    this.inquiryUuid,
    this.inquiryStatus,
    this.femaleUsers,
    this.femaleUser,
  });

  final String inquiryUuid;
  final InquiryStatus inquiryStatus;
  final List<FemaleUser> femaleUsers;
  final FemaleUser femaleUser;
}
