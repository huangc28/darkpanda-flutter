import 'package:equatable/equatable.dart';

class FcmPickupInquiry extends Equatable {
  FcmPickupInquiry({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmPickupInquiryContent fcmContent;
  final String deepLink;

  factory FcmPickupInquiry.fromMap(Map<String, dynamic> data) {
    return FcmPickupInquiry(
      fcmType: data['fcm_type'],
      fcmContent: FcmPickupInquiryContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmPickupInquiryContent extends Equatable {
  FcmPickupInquiryContent({
    this.pickerName,
    this.pickerUuid,
  });

  final String pickerName;
  final String pickerUuid;

  factory FcmPickupInquiryContent.fromMap(Map<String, dynamic> data) {
    return FcmPickupInquiryContent(
      pickerName: data['picker_name'],
      pickerUuid: data['picker_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'picker_name': pickerName,
        'picker_uuid': pickerUuid,
      };

  @override
  List<Object> get props => [
        pickerName,
        pickerUuid,
      ];
}
