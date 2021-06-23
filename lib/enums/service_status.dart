import 'package:enum_to_string/enum_to_string.dart';

enum ServiceStatus {
  unpaid,
  payment_failed,
  to_be_fulfilled,
  canceled,
  expired,
  fulfilling,
  completed,
}

/// Make an extension to convert string to enum.
extension EnumEx on String {
  ServiceStatus toServiceStatusEnum() =>
      EnumToString.fromString(ServiceStatus.values, toLowerCase());
}

extension InquiryStatusTypeExtension on ServiceStatus {
  String get name => EnumToString.convertToString(this);
}
