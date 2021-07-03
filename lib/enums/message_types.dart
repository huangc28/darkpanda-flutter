import 'package:enum_to_string/enum_to_string.dart';

enum MessageType {
  service_detail,
  text,
  images,
  confirmed_service,
  update_inquiry_detail,
  disagree_inquiry,
  quit_chatroom,
  complete_payment,
  start_service,
}

extension MessageTypeExtension on MessageType {
  String get name => EnumToString.convertToString(this);
}
