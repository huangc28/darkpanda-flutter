import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/recharge_amount.dart';

class Card {
  const Card({
    this.cardNo,
    this.expiryDate,
    this.cvv,
  });

  final String cardNo;
  final String expiryDate;
  final String cvv;

  Map<String, dynamic> toJson() => {
        'card_no': cardNo,
        'expiry_date': expiryDate,
        'cvv': cvv,
      };
}
