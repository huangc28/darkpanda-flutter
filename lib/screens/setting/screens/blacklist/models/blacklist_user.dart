class BlacklistUser {
  const BlacklistUser({
    this.id,
    this.userId,
    this.userName,
    this.avatarUrl,
    this.uuid,
  });

  final int id;
  final int userId;
  final String userName;
  final String avatarUrl;
  final String uuid;

  static BlacklistUser fromJson(Map<String, dynamic> data) {
    return BlacklistUser(
      id: data['id'],
      userId: data['user_id'],
      userName: data['username'],
      avatarUrl: data['avatar_url'],
      uuid: data['uuid'],
    );
  }
}
