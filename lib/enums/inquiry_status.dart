import 'package:flutter/foundation.dart';

enum InquiryStatus {
  inquiring,
  canceled,
  expired,
  booked,
  chatting,
  wait_for_inquirer_approve,
  asking,
}

/// Make an extension to convert string to enum.
extension EnumEx on String {
  InquiryStatus toInquiryStatusEnum() =>
      InquiryStatus.values.firstWhere((d) => describeEnum(d) == toLowerCase());
}

extension InquiryStatusTypeExtension on InquiryStatus {
  String get name {
    switch (this) {
      case InquiryStatus.inquiring:
        return 'inquiring';
      case InquiryStatus.canceled:
        return 'canceled';
      case InquiryStatus.expired:
        return 'expired';
      case InquiryStatus.booked:
        return 'booked';
      case InquiryStatus.chatting:
        return 'chatting';
      case InquiryStatus.wait_for_inquirer_approve:
        return 'wait_for_inquirer_approve';
      case InquiryStatus.asking:
        return 'asking';
      default:
        return null;
    }
  }
}
