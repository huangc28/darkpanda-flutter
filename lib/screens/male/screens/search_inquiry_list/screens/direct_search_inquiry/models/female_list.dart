import 'package:darkpanda_flutter/models/user_profile.dart';

class FemaleUser {
  FemaleUser({
    this.uuid,
    this.username,
    this.avatarUrl,
    this.age,
    this.height,
    this.weight,
    this.breastSize,
    this.description,
    this.userRating,
  });

  final String uuid;
  final String username;
  final String avatarUrl;
  final int age;
  final double height;
  final double weight;
  final String breastSize;
  final String description;
  final UserRating userRating;

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'username': username,
        'avatar_url': avatarUrl,
        'age': age,
        'height': height,
        'weight': weight,
        'breast_size': breastSize,
        'description': description,
        'user_rating': userRating,
      };

  factory FemaleUser.fromMap(Map<String, dynamic> data) {
    return FemaleUser(
      uuid: data['uuid'],
      username: data['username'],
      avatarUrl: data['avatar_url'],
      age: data['age'],
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      breastSize: data['breast_size'],
      description: data['description'],
      userRating: UserRating.fromMap(data['user_rating']),
    );
  }

  FemaleUser copyWith({
    String uuid,
    String username,
    String avatarUrl,
    int age,
    double height,
    double weight,
    String breastSize,
    String description,
    UserRating userRating,
  }) {
    return FemaleUser(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      breastSize: breastSize ?? this.breastSize,
      description: description ?? this.description,
      userRating: userRating ?? this.userRating,
    );
  }
}

class FemaleUserList {
  FemaleUserList({this.femaleUsers});

  List<FemaleUser> femaleUsers;

  Map<String, dynamic> toJson() => {
        'girls': femaleUsers,
      };

  static FemaleUserList fromJson(Map<String, dynamic> data) {
    List<FemaleUser> femaleUser = [];

    if (data['girls'] != null) {
      femaleUser = data['girls'].map<FemaleUser>((v) {
        return FemaleUser.fromMap(v);
      }).toList();
    }

    return FemaleUserList(
      femaleUsers: femaleUser,
    );
  }
}

class UserRating {
  UserRating({
    this.rateeId,
    this.score,
    this.numberOfServices,
  });

  final int rateeId;
  final double score;
  final int numberOfServices;

  factory UserRating.fromMap(Map<String, dynamic> data) {
    return UserRating(
      rateeId: data['ratee_id'],
      score: data['score']?.toDouble(),
      numberOfServices: data['number_of_services'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ratee_id': rateeId,
        'score': score,
        'number_of_services': numberOfServices,
      };
}
