class UserProfile {
  final String uuid;
  final String username;
  final String gender;
  final String avatarUrl;
  final String nationality;
  final String region;
  final int age;
  final double height;
  final double weight;
  final String description;

  const UserProfile({
    this.uuid,
    this.username,
    this.gender,
    this.avatarUrl,
    this.nationality,
    this.region,
    this.age,
    this.height,
    this.weight,
    this.description,
  });

  factory UserProfile.fromJson(Map<String, dynamic> data) {
    return UserProfile(
      uuid: data['uuid'],
      gender: data['gender'],
      username: data['username'],
      avatarUrl: data['avatar_url'],
      nationality: data['nationality'],
      region: data['region'],
      age: data['age'],
      height: data['height'],
      weight: data['weight'],
      description: data['description'],
    );
  }
}
