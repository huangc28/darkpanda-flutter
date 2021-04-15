import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/setting/screens/setting.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screens/topup_payment/topup_payment.dart';
import 'package:flutter/material.dart';

import 'topup_dp/components/body.dart';
import 'topup_dp/screen_arguements/args.dart';

class SettingRoutes extends BaseRoutes {
  static const root = '/';
  static const setting = '/setting';
  static const topup_payment = '/topup-payment';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SettingRoutes.root: (context) => Setting(),
      // SettingRoutes.topup_payment: (context) => TopupPayment(),
      SettingRoutes.topup_payment: (context) {
        final screenArgs = args as TopUpDpArguments;
        return Body(
          // loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
          args: screenArgs,
        );
        // return MultiBlocProvider(
        //   providers: [
        //     BlocProvider(
        //       create: (context) => LoadUserImagesBloc(
        //         userApi: UserApis(),
        //       ),
        //     ),
        //     BlocProvider(
        //       create: (context) => LoadHistoricalServicesBloc(
        //         userApi: UserApis(),
        //       ),
        //     ),
        //   ],
        //   child: InquirerProfile(
        //     loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
        //     args: screenArgs,
        //   ),
        // );
      }
    };
  }
}
