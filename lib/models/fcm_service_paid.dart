import 'package:equatable/equatable.dart';

class FcmServicePaid extends Equatable {
  FcmServicePaid({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmServicePaidContent fcmContent;
  final String deepLink;

  factory FcmServicePaid.fromMap(Map<String, dynamic> data) {
    return FcmServicePaid(
      fcmType: data['fcm_type'],
      fcmContent: FcmServicePaidContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmServicePaidContent extends Equatable {
  FcmServicePaidContent({
    this.payerName,
    this.serviceUuid,
  });

  final String payerName;
  final String serviceUuid;

  factory FcmServicePaidContent.fromMap(Map<String, dynamic> data) {
    return FcmServicePaidContent(
      payerName: data['payer_name'],
      serviceUuid: data['service_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'payer_name': payerName,
        'service_uuid': serviceUuid,
      };

  @override
  List<Object> get props => [
        payerName,
        serviceUuid,
      ];
}
