import 'package:enum_to_string/enum_to_string.dart';

enum FirebaseMessageType {
  pickup_inquiry,
  service_paid,
  unpaid_service_expired,
}

/// Make an extension to convert string to enum.
extension EnumEx on String {
  FirebaseMessageType toFirebaseMessageTypeEnum() =>
      EnumToString.fromString(FirebaseMessageType.values, toLowerCase());
}

extension FirebaseMessageTypeExtension on FirebaseMessageType {
  String get name => EnumToString.convertToString(this);
}
