import 'package:equatable/equatable.dart';

class FcmUnpaidServiceExpired extends Equatable {
  FcmUnpaidServiceExpired({
    this.fcmType,
    this.fcmContent,
    this.deepLink,
  });

  final String fcmType;
  final FcmUnpaidServiceExpiredContent fcmContent;
  final String deepLink;

  factory FcmUnpaidServiceExpired.fromMap(Map<String, dynamic> data) {
    return FcmUnpaidServiceExpired(
      fcmType: data['fcm_type'],
      fcmContent: FcmUnpaidServiceExpiredContent.fromMap(data['fcm_content']),
      deepLink: data['deep_link'],
    );
  }

  @override
  List<Object> get props => [fcmType, fcmContent, deepLink];
}

class FcmUnpaidServiceExpiredContent extends Equatable {
  FcmUnpaidServiceExpiredContent({
    this.customerName,
    this.serviceProviderName,
    this.serviceUuid,
  });

  final String customerName;
  final String serviceProviderName;
  final String serviceUuid;

  factory FcmUnpaidServiceExpiredContent.fromMap(Map<String, dynamic> data) {
    return FcmUnpaidServiceExpiredContent(
      customerName: data['customer_name'],
      serviceProviderName: data['service_provider_name'],
      serviceUuid: data['service_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'service_provider_name': serviceProviderName,
        'service_uuid': serviceUuid,
      };

  @override
  List<Object> get props => [
        customerName,
        serviceProviderName,
        serviceUuid,
      ];
}
