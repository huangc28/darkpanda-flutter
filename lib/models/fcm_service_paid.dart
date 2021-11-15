import 'package:equatable/equatable.dart';

class FcmServicePaid extends Equatable {
  FcmServicePaid({
    this.fcmType,
    this.payerName,
    this.serviceUuid,
  });

  final String fcmType;
  final String payerName;
  final String serviceUuid;

  factory FcmServicePaid.fromMap(Map<String, dynamic> data) {
    return FcmServicePaid(
      fcmType: data['fcm_type'],
      payerName: data['payer_name'],
      serviceUuid: data['service_uuid'],
    );
  }

  @override
  List<Object> get props => [
        fcmType,
        payerName,
        serviceUuid,
      ];
}
