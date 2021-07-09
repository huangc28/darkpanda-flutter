class BlacklistUser {
  const BlacklistUser({
    this.username,
    this.avatarUrl,
    this.uuid,
  });

  final String username;
  final String avatarUrl;
  final String uuid;

  static BlacklistUser fromJson(Map<String, dynamic> data) {
    return BlacklistUser(
      username: data['username'],
      avatarUrl: data['avatar_url'],
      uuid: data['uuid'],
    );
  }
}
