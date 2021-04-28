class BlacklistUser {
  const BlacklistUser({
    this.blacklistId,
    this.name,
    this.avatarUrl,
  });

  final int blacklistId;
  final String name;
  final String avatarUrl;

  static BlacklistUser fromJson(Map<String, dynamic> data) {
    return BlacklistUser(
      blacklistId: data['blacklist_id'],
      name: data['name'],
      avatarUrl: data['avatar_url'],
    );
  }
}
