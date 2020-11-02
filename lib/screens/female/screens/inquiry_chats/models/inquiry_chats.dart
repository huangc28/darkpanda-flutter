class InquiryChats {
  final String serviceType;
  final String username;
  final String avatarURL;
  final String channelUUID;
  final DateTime expiredAt;
  final DateTime createdAt;

  const InquiryChats({
    this.serviceType,
    this.username,
    this.avatarURL,
    this.channelUUID,
    this.expiredAt,
    this.createdAt,
  });

  factory InquiryChats.fromMap(Map<String, dynamic> data) => InquiryChats(
        serviceType: data['service_type'] ?? '',
        username: data['username'] ?? '',
        avatarURL: data['avatar_url'] ?? '',
        channelUUID: data['channel_uuid'] ?? '',
        expiredAt: DateTime.parse(data['expired_at']),
        createdAt: DateTime.parse(data['created_at']),
      );
}
