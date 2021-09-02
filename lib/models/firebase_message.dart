import 'package:equatable/equatable.dart';

class FirebaseMessage extends Equatable {
  FirebaseMessage({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FirebaseMessageContent fcmContent;
  final String deepLink;

  factory FirebaseMessage.fromMap(Map<String, dynamic> data) {
    return FirebaseMessage(
      fcmType: data['fcm_type'],
      fcmContent: FirebaseMessageContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FirebaseMessageContent extends Equatable {
  FirebaseMessageContent({
    this.pickerName,
    this.pickerUuid,
  });

  final String pickerName;
  final String pickerUuid;

  factory FirebaseMessageContent.fromMap(Map<String, dynamic> data) {
    return FirebaseMessageContent(
      pickerName: data['picker_name'],
      pickerUuid: data['picker_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'picker_name': pickerName,
        'picker_uuid': pickerUuid,
      };

  @override
  List<Object> get props => [pickerName, pickerUuid];
}
