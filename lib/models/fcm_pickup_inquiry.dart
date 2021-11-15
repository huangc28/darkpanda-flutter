import 'package:equatable/equatable.dart';

class FcmPickupInquiry extends Equatable {
  FcmPickupInquiry({
    this.fcmType,
    this.pickerName,
    this.pickerUuid,
  });

  final String fcmType;
  final String pickerName;
  final String pickerUuid;

  factory FcmPickupInquiry.fromMap(Map<String, dynamic> data) {
    return FcmPickupInquiry(
      fcmType: data['fcm_type'],
      pickerName: data['picker_name'],
      pickerUuid: data['picker_uuid'],
    );
  }

  @override
  List<Object> get props => [
        fcmType,
        pickerName,
        pickerUuid,
      ];
}
