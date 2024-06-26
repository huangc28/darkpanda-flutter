import 'package:darkpanda_flutter/enums/route_types.dart';
import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

class InquiryDetail extends Equatable {
  InquiryDetail({
    this.updateInquiryMessage,
    this.balance,
    this.username,
    this.channelUuid,
    this.inquiryUuid,
    this.counterPartUuid,
    this.serviceUuid,
    this.routeTypes,
    this.avatarUrl,
    this.serviceType,
  });

  UpdateInquiryMessage updateInquiryMessage;
  double balance;
  String username;
  String channelUuid;
  String inquiryUuid;
  String counterPartUuid;
  String serviceUuid;
  RouteTypes routeTypes;
  String avatarUrl;
  String serviceType;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory InquiryDetail.fromMap(Map<String, dynamic> data) {
    return InquiryDetail(
      updateInquiryMessage:
          UpdateInquiryMessage.fromMap(data['updateInquiryMessage']),
      balance: data['balance']?.toDouble(),
      username: data['username'] ?? '',
      channelUuid: data['channelUuid'] ?? '',
      inquiryUuid: data['inquiryUuid'] ?? '',
      counterPartUuid: data['counterPartUuid'] ?? '',
      serviceUuid: data['serviceUuid'] ?? '',
      routeTypes: data['routeTypes'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      serviceType: data['serviceType'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        updateInquiryMessage,
        balance,
        username,
        channelUuid,
        inquiryUuid,
        counterPartUuid,
        serviceUuid,
        routeTypes,
        avatarUrl,
        serviceType,
      ];
}
