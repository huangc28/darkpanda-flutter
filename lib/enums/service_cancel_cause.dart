import 'package:enum_to_string/enum_to_string.dart';

enum ServiceCancelCause {
  none,
  payment_failed,
  girl_cancel_before_appointment_time,
  girl_cancel_after_appointment_time,
  guy_cancel_before_appointment_time,
  guy_cancel_after_appointment_time,
}

/// Make an extension to convert string to enum.
extension EnumEx on String {
  ServiceCancelCause toServiceCancelCauseEnum() =>
      EnumToString.fromString(ServiceCancelCause.values, toLowerCase());
}

extension ServiceCancelCauseTypeExtension on ServiceCancelCause {
  String get name => EnumToString.convertToString(this);
}
