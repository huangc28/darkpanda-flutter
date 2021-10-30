import 'package:equatable/equatable.dart';

class FcmServiceCancelled extends Equatable {
  FcmServiceCancelled({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmServiceCancelledContent fcmContent;
  final String deepLink;

  factory FcmServiceCancelled.fromMap(Map<String, dynamic> data) {
    return FcmServiceCancelled(
      fcmType: data['fcm_type'],
      fcmContent: FcmServiceCancelledContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmServiceCancelledContent extends Equatable {
  FcmServiceCancelledContent({
    this.serviceUuid,
    this.cancellerUuid,
    this.cancellerUsername,
  });

  final String serviceUuid;
  final String cancellerUuid;
  final String cancellerUsername;

  factory FcmServiceCancelledContent.fromMap(Map<String, dynamic> data) {
    return FcmServiceCancelledContent(
      serviceUuid: data['service_uuid'],
      cancellerUuid: data['canceller_uuid'],
      cancellerUsername: data['canceller_username'],
    );
  }

  Map<String, dynamic> toJson() => {
        'service_uuid': serviceUuid,
        'canceller_uuid': cancellerUuid,
        'canceller_username': cancellerUsername,
      };

  @override
  List<Object> get props => [
        serviceUuid,
        cancellerUuid,
        cancellerUsername,
      ];
}
