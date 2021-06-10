enum MessageType {
  service_detail,
  text,
  confirmed_service,
  update_inquiry_detail,
  disagree_inquiry,
}

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.service_detail:
        return 'service_detail';
      case MessageType.text:
        return 'text';
      case MessageType.confirmed_service:
        return 'confirmed_service';
      case MessageType.update_inquiry_detail:
        return 'update_inquiry_detail';
      case MessageType.disagree_inquiry:
        return 'disagree_inquiry';
      default:
        return null;
    }
  }
}
