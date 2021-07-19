import 'user_image.dart';

class UserProfile {
  final String uuid;
  final String username;
  final String nickname;
  final String gender;
  final String avatarUrl;
  final String nationality;
  final String region;
  final int age;
  final double height;
  final double weight;
  final String description;
  final List<UserImage> imageList;
  final List<UserImage> removeImageList;

  const UserProfile({
    this.uuid,
    this.username,
    this.nickname,
    this.gender,
    this.avatarUrl,
    this.nationality,
    this.region,
    this.age,
    this.height,
    this.weight,
    this.description,
    this.imageList,
    this.removeImageList,
  });

  factory UserProfile.fromJson(Map<String, dynamic> data) {
    return UserProfile(
      uuid: data['uuid'],
      gender: data['gender'],
      username: data['username'],
      nickname: data['nickname'],
      avatarUrl: data['avatar_url'],
      nationality: data['nationality'],
      region: data['region'],
      age: data['age'],
      height:
          data['height'] != null ? data['height'].toDouble() : data['height'],
      weight:
          data['weight'] != null ? data['weight'].toDouble() : data['weight'],
      description: data['description'],
    );
  }

  UserProfile copyWith({
    String uuid,
    String username,
    String nickname,
    String gender,
    String avatarUrl,
    String nationality,
    String region,
    int age,
    double height,
    double weight,
    String description,
    List<UserImage> imageList,
    List<UserImage> removeImageList,
  }) {
    return UserProfile(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nationality: nationality ?? this.nationality,
      region: region ?? this.region,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      imageList: imageList ?? this.imageList,
      removeImageList: removeImageList ?? this.removeImageList,
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'username': username,
        'nickname': nickname,
        'gender': gender,
        'avatar_url': avatarUrl,
        'nationality': nationality,
        'region': region,
        'age': age,
        'height': height,
        'weight': weight,
        'description': description,
        'imageList': imageList,
        'removeImageList': removeImageList,
      };
}
