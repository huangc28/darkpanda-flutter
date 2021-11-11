import 'package:equatable/equatable.dart';

class FcmServiceCancelled extends Equatable {
  FcmServiceCancelled({
    this.fcmType,
    this.serviceUuid,
    this.cancellerUuid,
    this.cancellerUsername,
  });

  final String fcmType;
  final String serviceUuid;
  final String cancellerUuid;
  final String cancellerUsername;

  factory FcmServiceCancelled.fromMap(Map<String, dynamic> data) {
    return FcmServiceCancelled(
      fcmType: data['fcm_type'],
      serviceUuid: data['service_uuid'],
      cancellerUuid: data['canceller_uuid'],
      cancellerUsername: data['canceller_username'],
    );
  }

  @override
  List<Object> get props => [
        fcmType,
        serviceUuid,
        cancellerUuid,
        cancellerUsername,
      ];
}
