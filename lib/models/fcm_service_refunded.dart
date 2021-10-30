import 'package:equatable/equatable.dart';

class FcmServiceRefunded extends Equatable {
  FcmServiceRefunded({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmServiceRefundedContent fcmContent;
  final String deepLink;

  factory FcmServiceRefunded.fromMap(Map<String, dynamic> data) {
    return FcmServiceRefunded(
      fcmType: data['fcm_type'],
      fcmContent: FcmServiceRefundedContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmServiceRefundedContent extends Equatable {
  FcmServiceRefundedContent({
    this.serviceUuid,
  });

  final String serviceUuid;

  factory FcmServiceRefundedContent.fromMap(Map<String, dynamic> data) {
    return FcmServiceRefundedContent(
      serviceUuid: data['service_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'service_uuid': serviceUuid,
      };

  @override
  List<Object> get props => [
        serviceUuid,
      ];
}
