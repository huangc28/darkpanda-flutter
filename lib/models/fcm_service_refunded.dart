import 'package:equatable/equatable.dart';

class FcmServiceRefunded extends Equatable {
  FcmServiceRefunded({
    this.fcmType,
    this.serviceUuid,
  });

  final String fcmType;
  final String serviceUuid;

  factory FcmServiceRefunded.fromMap(Map<String, dynamic> data) {
    return FcmServiceRefunded(
      fcmType: data['fcm_type'],
      serviceUuid: data['service_uuid'],
    );
  }

  @override
  List<Object> get props => [
        fcmType,
        serviceUuid,
      ];
}
