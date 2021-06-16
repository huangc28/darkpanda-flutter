import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

class InquiryDetail extends Equatable {
  InquiryDetail({
    this.updateInquiryMessage,
    this.balance,
    this.username,
  });

  UpdateInquiryMessage updateInquiryMessage;
  int balance;
  String username;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory InquiryDetail.fromMap(Map<String, dynamic> data) {
    return InquiryDetail(
      updateInquiryMessage:
          UpdateInquiryMessage.fromMap(data['updateInquiryMessage']),
      balance: data['balance'] ?? 0,
      username: data['username'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        updateInquiryMessage,
        balance,
        username,
      ];
}
