class RegisteredUser {
  final String username;
  final bool phoneVerified;
  final String gender;
  final String uuid;

  RegisteredUser({
    this.username,
    this.phoneVerified,
    this.gender,
    this.uuid,
  });

  static RegisteredUser fromJson(Map<String, dynamic> data) {
    return RegisteredUser(
      username: data['username'],
      phoneVerified: data['phone_verified'],
      gender: data['gender'],
      uuid: data['uuid'],
    );
  }
}
