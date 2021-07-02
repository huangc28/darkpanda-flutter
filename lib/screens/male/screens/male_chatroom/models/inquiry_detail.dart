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
  });

  UpdateInquiryMessage updateInquiryMessage;
  int balance;
  String username;
  String channelUuid;
  String inquiryUuid;
  String counterPartUuid;
  String serviceUuid;
  RouteTypes routeTypes;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory InquiryDetail.fromMap(Map<String, dynamic> data) {
    return InquiryDetail(
      updateInquiryMessage:
          UpdateInquiryMessage.fromMap(data['updateInquiryMessage']),
      balance: data['balance'] ?? 0,
      username: data['username'] ?? '',
      channelUuid: data['channelUuid'] ?? '',
      inquiryUuid: data['inquiryUuid'] ?? '',
      counterPartUuid: data['counterPartUuid'] ?? '',
      serviceUuid: data['serviceUuid'] ?? '',
      routeTypes: data['routeTypes'] ?? '',
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
      ];
}
