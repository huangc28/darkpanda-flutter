enum MessageType {
  service_detail,
  text,
}

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.service_detail:
        return 'service_detail';
      case MessageType.text:
        return 'text';
      default:
        return null;
    }
  }
}
