import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/services/apis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/blacklist.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/bloc/load_blacklist_user_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/bloc/remove_blacklist_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/setting.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/topup_dp.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/bank_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'topup_dp/components/body.dart';
import 'topup_dp/screen_arguements/args.dart';
import 'topup_dp/services/apis.dart';

import 'bank_account/bloc/load_bank_status_bloc.dart';
import 'bank_account/bloc/verify_bank_bloc.dart';

class SettingRoutes extends BaseRoutes {
  static const root = '/';
  static const setting = '/setting';
  static const topup_payment = '/topup-payment';
  static const topup_dp = '/topup-dp';
  static const blacklist = '/blacklist';
  static const bank_account = '/bank-account';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SettingRoutes.root: (context) => Setting(
            onPush: (String routeName, TopUpDpArguments args) =>
                this.push(context, routeName, args),
          ),
      SettingRoutes.blacklist: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoadBlacklistUserBloc(
                  blacklistApiClient: BlacklistApiClient()),
            ),
            BlocProvider(
              create: (context) => RemoveBlacklistBloc(
                blacklistApiClient: BlacklistApiClient(),
              ),
            ),
          ],
          child: BlackList(),
        );
      },
      SettingRoutes.topup_dp: (context) => TopupDp(
            onPush: (String routeName, TopUpDpArguments args) =>
                this.push(context, routeName, args),
          ),
      SettingRoutes.topup_payment: (context) {
        final screenArgs = args as TopUpDpArguments;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => BuyDpBloc(
                apiClient: TopUpClient(),
              ),
            ),
          ],
          child: TopupDp(
            args: screenArgs,
          ),
        );
      },
      SettingRoutes.bank_account: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoadBankStatusBloc(
                bankAPIClient: BankAPIClient(),
              ),
            ),
          ],
          child: BankAccount(),
        );
      }
    };
  }
}
