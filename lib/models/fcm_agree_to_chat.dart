import 'package:equatable/equatable.dart';

class FcmAgreeToChat extends Equatable {
  FcmAgreeToChat({
    this.fcmType,
    this.inquiryUuid,
    this.maleUsername,
    this.femaleUsername,
  });

  final String fcmType;
  final String inquiryUuid;
  final String maleUsername;
  final String femaleUsername;

  factory FcmAgreeToChat.fromMap(Map<String, dynamic> data) {
    return FcmAgreeToChat(
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
