import 'package:equatable/equatable.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:darkpanda_flutter/enums/gender.dart';

class AuthUser extends Equatable {
  final String jwt;
  final String username;
  final String avatarUrl;
  final String uuid;
  final Gender gender;
  final String fcmTopic;

  AuthUser({
    this.jwt,
    this.username,
    this.avatarUrl,
    this.uuid,
    this.gender,
    this.fcmTopic,
  });

  factory AuthUser.copyFrom(
    AuthUser user, {
    String jwt,
    String username,
    String avatarUrl,
    String uuid,
    String gender,
    String fcmTopic,
  }) {
    return AuthUser(
      jwt: jwt ?? user.jwt,
      username: username ?? user.username,
      avatarUrl: avatarUrl ?? user.avatarUrl,
      uuid: uuid ?? user.uuid,
      gender: gender ?? user.gender,
      fcmTopic: fcmTopic ?? user.fcmTopic,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> data) {
    return AuthUser(
      jwt: data['jwt'],
      username: data['username'],
      avatarUrl: data['avatarUrl'],
      uuid: data['uuid'],
      gender: EnumToString.fromString(Gender.values, data['gender']),
      fcmTopic: data['fcm_topic'],
    );
  }
  @override
  List<Object> get props => [
        jwt,
        username,
        avatarUrl,
        uuid,
        gender,
        fcmTopic,
      ];
}
