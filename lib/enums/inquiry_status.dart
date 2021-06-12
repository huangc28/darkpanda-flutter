import 'package:enum_to_string/enum_to_string.dart';

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
      EnumToString.fromString(InquiryStatus.values, toLowerCase());
}

extension InquiryStatusTypeExtension on InquiryStatus {
  String get name => EnumToString.convertToString(this);
}
