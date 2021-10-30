import 'package:equatable/equatable.dart';

class FcmAgreeToChat extends Equatable {
  FcmAgreeToChat({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmAgreeToChatContent fcmContent;
  final String deepLink;

  factory FcmAgreeToChat.fromMap(Map<String, dynamic> data) {
    return FcmAgreeToChat(
      fcmType: data['fcm_type'],
      fcmContent: FcmAgreeToChatContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmAgreeToChatContent extends Equatable {
  FcmAgreeToChatContent({
    this.inquiryUuid,
    this.maleUsername,
    this.femaleUsername,
  });

  final String inquiryUuid;
  final String maleUsername;
  final String femaleUsername;

  factory FcmAgreeToChatContent.fromMap(Map<String, dynamic> data) {
    return FcmAgreeToChatContent(
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
