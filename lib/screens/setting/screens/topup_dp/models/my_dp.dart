import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/recharge_amount.dart';

class MyDp {
  MyDp({
    this.balance,
    this.RechargeAmountLists,
  });

  double balance;
  final List<RechargeAmount> RechargeAmountLists;

  static MyDp fromJson(Map<String, dynamic> data) {
    List<RechargeAmount> RechargeAmountLists = [];

    if (data.containsKey('recharge_amount_list')) {
      RechargeAmountLists =
          data['recharge_amount_list'].map<RechargeAmount>((rechargeAmount) {
        return RechargeAmount.fromJson(rechargeAmount);
      }).toList();
    }

    return MyDp(
      balance: data['balance']?.toDouble(),
      RechargeAmountLists: RechargeAmountLists,
    );
  }
}
