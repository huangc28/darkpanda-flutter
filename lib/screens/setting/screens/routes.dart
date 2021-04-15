import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/setting/screens/setting.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screens/topup_payment/topup_payment.dart';
import 'package:flutter/material.dart';

class SettingRoutes extends BaseRoutes {
  static const root = '/';
  static const setting = '/setting';
  static const topup_payment = 'topup-payment';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SettingRoutes.root: (context) => Setting(),
      SettingRoutes.topup_payment: (context) => TopupPayment(),
    };
  }
}
