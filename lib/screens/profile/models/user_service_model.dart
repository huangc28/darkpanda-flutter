import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

class UserServiceModel {
  UserServiceModel({
    this.serviceName,
    this.price,
    this.optionType,
    this.description,
    this.duration,
  });

  final String serviceName;
  final double price;
  final String optionType;
  final String description;
  final int duration;

  factory UserServiceModel.fromMap(Map<String, dynamic> data) {
    return UserServiceModel(
      serviceName: data['service_name'],
      price: data['price'],
      optionType: data['option_type'],
      description: data['description'],
      duration: data['duration'],
    );
  }

  Map<String, dynamic> toMap() => {
        'service_name': serviceName,
        'price': price.toDouble(),
        'option_type': optionType,
        'description': description,
        'duration': duration,
      };

  UserServiceModel copyWith({
    String serviceName,
    double price,
    String optionType,
    String description,
    int duration,
  }) {
    return UserServiceModel(
      serviceName: serviceName ?? this.serviceName,
      price: price ?? this.price,
      optionType: optionType ?? this.optionType,
      description: description ?? this.description,
      duration: duration ?? this.duration,
    );
  }
}
