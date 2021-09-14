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
    this.payerName,
    this.customerName,
    this.serviceProviderName,
    this.serviceUuid,
  });

  final String pickerName;
  final String pickerUuid;
  final String payerName;
  final String customerName;
  final String serviceProviderName;
  final String serviceUuid;

  factory FirebaseMessageContent.fromMap(Map<String, dynamic> data) {
    return FirebaseMessageContent(
      pickerName: data['picker_name'],
      pickerUuid: data['picker_uuid'],
      payerName: data['payer_name'],
      serviceProviderName: data['service_provider_name'],
      serviceUuid: data['service_uuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'picker_name': pickerName,
        'picker_uuid': pickerUuid,
        'payer_name': payerName,
        'customer_name': customerName,
        'service_provider_name': serviceProviderName,
        'service_uuid': serviceUuid,
      };

  @override
  List<Object> get props => [
        pickerName,
        pickerUuid,
        payerName,
        customerName,
        serviceProviderName,
        serviceUuid,
      ];
}
