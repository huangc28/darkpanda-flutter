import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

class NegotiatingServiceDetail {
  NegotiatingServiceDetail({
    this.serviceUUID,
    this.channelUUID,
    this.counterPartUUID,
    this.inquiryUUID,
    this.serviceType,
    this.address,
    this.serviceTime,
    this.duration,
    this.price,
    this.username,
  });

  String serviceUUID;
  String channelUUID;
  String counterPartUUID;
  String inquiryUUID;

  String serviceType;
  String address;
  DateTime serviceTime;
  Duration duration;
  double price;
  String username;

  /// copyWithUpdateInquiryMessage copies necessary attributes from
  /// [UpdateInquiryMessage] to proceed to confirm service.
  NegotiatingServiceDetail copyWithUpdateInquiryMessage(
      UpdateInquiryMessage message) {
    this.serviceType = message.serviceType ?? this.serviceType;
    this.price = message.price ?? this.price;
    this.address = message.address ?? this.address;
    this.serviceTime = message.serviceTime ?? this.serviceTime;
    this..duration = message.duration ?? this.duration;
    this.username = message.username ?? this.username;

    return this;
  }

  NegotiatingServiceDetail copy({
    String serviceUUID,
    String channelUUID,
    String counterPartUUID,
    String inquiryUUID,
  }) {
    this.serviceUUID = serviceUUID ?? this.serviceUUID;
    this.channelUUID = channelUUID ?? this.channelUUID;
    this.counterPartUUID = counterPartUUID ?? this.counterPartUUID;
    this.inquiryUUID = inquiryUUID ?? this.inquiryUUID;

    return this;
  }
}
