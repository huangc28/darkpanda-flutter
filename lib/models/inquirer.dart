import 'package:equatable/equatable.dart';

class Inquirer extends Equatable {
  final String uuid;
  final String username;
  final String avatarURL;
  final String nationality;

  const Inquirer({
    this.uuid,
    this.username,
    this.avatarURL,
    this.nationality,
  });

  factory Inquirer.fromJson(Map<String, dynamic> data) => Inquirer(
        uuid: data['uuid'],
        username: data['username'],
        avatarURL: data['avatar_url'],
        nationality: data['nationality'],
      );

  List<Object> get props => [
        uuid,
        username,
        avatarURL,
        nationality,
      ];
}
