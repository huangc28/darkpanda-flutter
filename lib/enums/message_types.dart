import 'package:enum_to_string/enum_to_string.dart';

enum MessageType {
  service_detail,
  text,
  confirmed_service,
  update_inquiry_detail,
  disagree_inquiry,
  quit_chatroom,
  completed_payment,
}

extension MessageTypeExtension on MessageType {
  String get name => EnumToString.convertToString(this);
}
