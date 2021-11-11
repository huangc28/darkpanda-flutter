import 'package:equatable/equatable.dart';

class FcmMaleSendDirectInquiry extends Equatable {
  FcmMaleSendDirectInquiry({
    this.fcmType,
    this.inquiryUuid,
    this.maleUsername,
    this.femaleUsername,
  });

  final String fcmType;
  final String inquiryUuid;
  final String maleUsername;
  final String femaleUsername;

  factory FcmMaleSendDirectInquiry.fromMap(Map<String, dynamic> data) {
    return FcmMaleSendDirectInquiry(
      fcmType: data['fcm_type'],
      inquiryUuid: data['inquiry_uuid'],
      maleUsername: data['male_username'],
      femaleUsername: data['female_username'],
    );
  }

  @override
  List<Object> get props => [
        fcmType,
        inquiryUuid,
        maleUsername,
        femaleUsername,
      ];
}
