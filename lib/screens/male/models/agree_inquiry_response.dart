import 'package:equatable/equatable.dart';

class AgreeInquiryResponse extends Equatable {
  AgreeInquiryResponse({
    this.picker,
    this.inquirer,
    this.channelUuid,
    this.serviceType,
    this.inquiryStatus,
  });

  Picker picker;
  Inquirer inquirer;
  String channelUuid;
  String serviceType;
  String inquiryStatus;

  AgreeInquiryResponse.fromMap(Map<String, dynamic> data)
      : picker = Picker.fromMap(data['picker']),
        inquirer = Inquirer.fromMap(data['inquirer']),
        channelUuid = data['channel_uuid'],
        serviceType = data['service_type'],
        inquiryStatus = data['inquiry_status'];

  Map<String, dynamic> toMap() => {
        'picker': picker,
        'inquirer': inquirer,
        'channel_uuid': channelUuid,
        'service_type': serviceType,
        'inquiry_status': inquiryStatus,
      };

  @override
  List<Object> get props => [
        picker,
        inquirer,
        channelUuid,
        serviceType,
        inquiryStatus,
      ];
}

class Picker {
  Picker({
    this.username,
    this.avatarUrl,
    this.uuid,
    this.rating,
    this.description,
  });

  String username;
  String avatarUrl;
  String uuid;
  int rating;
  String description;

  Picker.fromMap(Map<String, dynamic> data)
      : username = data['username'],
        avatarUrl = data['avatar_url'],
        uuid = data['uuid'],
        rating = data['rating'],
        description = data['description'];

  Map<String, dynamic> toMap() => {
        'username': username,
        'avatar_url': avatarUrl,
        'uuid': uuid,
        'rating': rating,
        'description': description,
      };
}

class Inquirer {
  Inquirer({
    this.username,
    this.avatarUrl,
    this.uuid,
    this.rating,
    this.description,
  });

  String username;
  String avatarUrl;
  String uuid;
  int rating;
  String description;

  Inquirer.fromMap(Map<String, dynamic> data)
      : username = data['username'],
        avatarUrl = data['avatar_url'],
        uuid = data['uuid'],
        rating = data['rating'],
        description = data['description'];

  Map<String, dynamic> toMap() => {
        'username': username,
        'avatar_url': avatarUrl,
        'uuid': uuid,
        'rating': rating,
        'description': description,
      };
}
