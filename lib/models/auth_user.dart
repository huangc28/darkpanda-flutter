class AuthUser {
  final String jwt;
  final String username;
  final String avatarUrl;
  final String uuid;
  final String gender;

  AuthUser({
    this.jwt,
    this.username,
    this.avatarUrl,
    this.uuid,
    this.gender,
  });

  factory AuthUser.copyFrom(
    AuthUser user, {
    String jwt,
    String username,
    String avatarUrl,
    String uuid,
    String gender,
  }) {
    return AuthUser(
      jwt: jwt ?? user.jwt,
      username: username ?? user.username,
      avatarUrl: avatarUrl ?? user.avatarUrl,
      uuid: uuid ?? user.uuid,
      gender: gender ?? user.gender,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> data) {
    return AuthUser(
      jwt: data['jwt'],
      username: data['username'],
      avatarUrl: data['avatarUrl'],
      uuid: data['uuid'],
      gender: data['gender'],
    );
  }
}
