import 'package:enum_to_string/enum_to_string.dart';

enum FirebaseMessageType {
  pickup_inquiry,
  service_paid,
  unpaid_service_expired,
  agree_to_chat,
  service_cancelled,
  refunded,
  male_send_direct_inquiry,
}

/// Make an extension to convert string to enum.
extension EnumEx on String {
  FirebaseMessageType toFirebaseMessageTypeEnum() =>
      EnumToString.fromString(FirebaseMessageType.values, toLowerCase());
}

extension FirebaseMessageTypeExtension on FirebaseMessageType {
  String get name => EnumToString.convertToString(this);
}
