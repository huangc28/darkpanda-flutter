import 'package:equatable/equatable.dart';

class FcmUnpaidServiceExpired extends Equatable {
  FcmUnpaidServiceExpired({
    this.fcmType,
    this.customerName,
    this.serviceProviderName,
    this.serviceUuid,
  });

  final String fcmType;
  final String customerName;
  final String serviceProviderName;
  final String serviceUuid;

  factory FcmUnpaidServiceExpired.fromMap(Map<String, dynamic> data) {
    return FcmUnpaidServiceExpired(
      fcmType: data['fcm_type'],
      customerName: data['customer_name'],
      serviceProviderName: data['service_provider_name'],
      serviceUuid: data['service_uuid'],
    );
  }

  @override
  List<Object> get props => [
        fcmType,
        customerName,
        serviceProviderName,
        serviceUuid,
      ];
}
