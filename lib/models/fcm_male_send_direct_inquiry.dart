import 'package:equatable/equatable.dart';

class FcmMaleSendDirectInquiry extends Equatable {
  FcmMaleSendDirectInquiry({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmMaleSendDirectInquiryContent fcmContent;
  final String deepLink;

  factory FcmMaleSendDirectInquiry.fromMap(Map<String, dynamic> data) {
    return FcmMaleSendDirectInquiry(
      fcmType: data['fcm_type'],
      fcmContent: FcmMaleSendDirectInquiryContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmMaleSendDirectInquiryContent extends Equatable {
  FcmMaleSendDirectInquiryContent({
    this.inquiryUuid,
    this.maleUsername,
    this.femaleUsername,
  });

  final String inquiryUuid;
  final String maleUsername;
  final String femaleUsername;

  factory FcmMaleSendDirectInquiryContent.fromMap(Map<String, dynamic> data) {
    return FcmMaleSendDirectInquiryContent(
      inquiryUuid: data['inquiry_uuid'],
      maleUsername: data['male_username'],
      femaleUsername: data['female_username'],
    );
  }

  Map<String, dynamic> toJson() => {
        'inquiry_uuid': inquiryUuid,
        'male_username': maleUsername,
        'female_username': femaleUsername,
      };

  @override
  List<Object> get props => [
        inquiryUuid,
        maleUsername,
        femaleUsername,
      ];
}
