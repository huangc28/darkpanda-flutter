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
