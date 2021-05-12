import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/recharge_amount.dart';

class PaymentCard {
  PaymentCard({
    this.number,
    this.name,
    this.month,
    this.year,
    this.cvv,
    this.prime,
  });

  String number;
  String name;
  String month;
  String year;
  int cvv;
  String prime;

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'month': month,
        'year': year,
        'cvv': cvv,
        'prime': prime,
      };
}

class BuyCoin {
  String uuid;
  int rechargeId;
  int amount;
  int cost;
  String paymentType;
  PaymentCard paymentCard;

  BuyCoin({
    this.uuid,
    this.rechargeId,
    this.amount,
    this.cost,
    this.paymentType,
    this.paymentCard,
  });

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'rechargeId': rechargeId,
        'amount': amount,
        'cost': cost,
        'paymentType': paymentType,
        'paymentCard': paymentCard,
      };
}
