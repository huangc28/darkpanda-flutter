import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class UserServiceResponse {
  UserServiceResponse({
    this.serviceName,
    this.price,
    this.optionType,
    this.description,
    this.duration,
    this.serviceOptionId,
  });

  final String serviceName;
  final double price;
  final String optionType;
  final String description;
  final int duration;
  final int serviceOptionId;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory UserServiceResponse.fromMap(Map<String, dynamic> data) {
    return UserServiceResponse(
      serviceName: data['service_name'],
      price: data['price'].toDouble(),
      optionType: data['option_type'],
      description: data['description'],
      duration: data['duration'],
      serviceOptionId: data['service_option_id'],
    );
  }

  Map<String, dynamic> toMap() => {
        'service_name': serviceName,
        'price': price,
        'option_type': optionType,
        'description': description,
        'duration': duration,
        'service_option_id': serviceOptionId,
      };
}

class UserServiceListResponse {
  UserServiceListResponse({this.userServiceList});

  final List<UserServiceResponse> userServiceList;

  factory UserServiceListResponse.fromMap(Map<String, dynamic> data) {
    List<UserServiceResponse> serviceList = [];

    if (data['user_service'] != null) {
      serviceList = data['user_service'].map<UserServiceResponse>((v) {
        return UserServiceResponse.fromMap(v);
      }).toList();
    }

    return UserServiceListResponse(
      userServiceList: serviceList,
    );
  }
}
