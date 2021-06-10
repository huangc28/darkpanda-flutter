import 'package:equatable/equatable.dart';

import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class UpdateInquiryMessage extends Equatable {
  UpdateInquiryMessage({
    this.content,
    this.from,
    this.to,
    this.createdAt,
    this.price,
    this.duration,
  });

  final String content;
  final String from;
  final String to;
  final DateTime createdAt;
  final double price;
  final int duration;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory UpdateInquiryMessage.fromMap(Map<String, dynamic> data) {
    return UpdateInquiryMessage(
      content: data['content'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      createdAt: UpdateInquiryMessage.fieldToDateTime(data['created_at']),
      price: data['price'] ?? '',
      duration: data['duration'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        content,
        from,
        to,
        createdAt,
        price,
        duration,
      ];
}
