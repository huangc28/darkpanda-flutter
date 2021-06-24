import 'dart:developer' as developer;

class PaymentDetail {
  PaymentDetail({
    this.price,
    this.recTradeId,
    this.address,
    this.startTime,
    this.duration,
    this.pickerUuid,
    this.pickerUsername,
    this.pickerAvatarUrl,
    this.hasCommented,
  });

  int price;
  String recTradeId;
  String address;
  DateTime startTime;
  Duration duration;
  String pickerUuid;
  String pickerUsername;
  String pickerAvatarUrl;
  bool hasCommented;

  Map<String, dynamic> toMap() => {
        'price': price,
        'rec_trade_id': recTradeId,
        'address': address,
        'start_time': startTime,
        'duration': duration,
        'picker_uuid': pickerUuid,
        'picker_username': pickerUsername,
        'picker_avatar_url': pickerAvatarUrl,
        'has_commented': hasCommented,
      };

  factory PaymentDetail.fromMap(Map<String, dynamic> data) {
    return PaymentDetail(
      price: data['price'],
      recTradeId: data['rec_trade_id'],
      address: data['address'],
      startTime: data['start_time'],
      duration: data['duration'],
      pickerUuid: data['picker_uuid'],
      pickerUsername: data['picker_username'],
      pickerAvatarUrl: data['picker_avatar_url'],
      hasCommented: data['has_commented'],
    );
  }

  factory PaymentDetail.fromJson(Map<String, dynamic> data) {
    var parsedStartTime = DateTime.now();

    // The appointment time may be `null`. If the parsed result is `null`, we use
    // current date as the `appointmentTime` and log the errorneous datetime
    if (data['start_time'] != null) {
      parsedStartTime = DateTime.tryParse(data['start_time']);
    } else {
      developer.log(
        '${data['rec_trade_id']}: ${data['start_time']} can not be parse to DateTime object',
        name: 'Failed to parse datetime string to DateTime object',
      );
    }

    var parsedDuration = Duration(minutes: 60);

    if (data['duration'] != null) {
      parsedDuration = Duration(minutes: data['duration']);
    } else {
      developer.log(
        '${data['rec_trade_id']}: ${data['duration']} can not be parse to Duration object',
        name: 'Failed to parse datetime string to Duration object',
      );
    }

    return PaymentDetail(
      price: data['price'],
      recTradeId: data['rec_trade_id'],
      address: data['address'],
      startTime: parsedStartTime,
      duration: parsedDuration,
      pickerUuid: data['picker_uuid'],
      pickerUsername: data['picker_username'],
      pickerAvatarUrl: data['picker_avatar_url'],
      hasCommented: data['has_commented'],
    );
  }
}
