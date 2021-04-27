import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/models/recharge_amount.dart';

class MyDp {
  const MyDp({
    this.currentDpCoin,
    this.RechargeAmountLists,
  });

  final double currentDpCoin;
  final List<RechargeAmount> RechargeAmountLists;

  static MyDp fromJson(Map<String, dynamic> data) {
    List<RechargeAmount> RechargeAmountLists = [];

    if (data.containsKey('recharge_amount_list')) {
      RechargeAmountLists =
          data['recharge_amount_list'].map<RechargeAmount>((RechargeAmount) {
        return RechargeAmount.fromJson(RechargeAmount);
      }).toList();
    }

    return MyDp(
      currentDpCoin: data['current_dp_coin'],
      RechargeAmountLists: RechargeAmountLists,
    );
  }
}
