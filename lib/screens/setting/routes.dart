import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/models/inquiry_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/auth_user_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/blacklist.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/bloc/load_blacklist_user_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/bloc/remove_blacklist_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/blacklist/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/buy_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/topup_dp.dart';
import 'package:darkpanda_flutter/screens/setting/screens/bank_account/bank_account.dart';
import 'package:darkpanda_flutter/enums/gender.dart';

import 'screens/topup_dp/bloc/load_dp_package_bloc.dart';
import 'screens/topup_dp/bloc/load_my_dp_bloc.dart';
import 'screens/topup_dp/screen_arguements/args.dart';
import 'screens/topup_dp/services/apis.dart';

import 'screens/bank_account/bloc/load_bank_status_bloc.dart';
import 'screens/female/settings.dart';
import 'screens/male/settings.dart';

import 'bloc/logout_bloc.dart';
import 'screens/verify_phone/bloc/send_change_mobile_bloc.dart';
import 'screens/verify_phone/services/change_mobile_apis.dart';
import 'screens/verify_phone/verify_phone.dart';
import 'services/settings_apis.dart';

class SettingRoutes extends BaseRoutes {
  static const root = '/';
  static const setting = '/setting';
  static const topup_payment = '/topup-payment';
  static const topup_dp = '/topup-dp';
  static const blacklist = '/blacklist';
  static const bank_account = '/bank-account';
  static const verify_phone = '/verify-phone';

  SettingRoutes();

  WidgetBuilder _buildFemaleSettingPage() {
    return (context) => BlocProvider(
          create: (context) => LogoutBloc(
            authUserBloc: BlocProvider.of<AuthUserBloc>(context),
            settingsApi: SettingsAPIClient(),
          ),
          child: FemaleSettings(
            onPush: (String routeName, TopUpDpArguments args) =>
                this.push(context, routeName, args),
          ),
        );
  }

  WidgetBuilder _buildMaleSettingPage() {
    return (context) => BlocProvider(
          create: (context) => LogoutBloc(
            authUserBloc: BlocProvider.of<AuthUserBloc>(context),
            settingsApi: SettingsAPIClient(),
          ),
          child: MaleSettings(
            onPushTopupDP: (TopUpDpArguments args) =>
                this.push(context, SettingRoutes.topup_dp, args),
          ),
        );
  }

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    // Display proper settings page by determining gender from auth user.
    final gender = BlocProvider.of<AuthUserBloc>(context).state.user.gender;

    return {
      SettingRoutes.root: gender == Gender.female
          ? _buildFemaleSettingPage()
          : _buildMaleSettingPage(),
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
      SettingRoutes.topup_dp: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoadMyDpBloc(
                apiClient: TopUpClient(),
              ),
            ),
            BlocProvider(
              create: (context) => LoadDpPackageBloc(
                apiClient: TopUpClient(),
              ),
            ),
          ],
          child: TopupDp(
            onPush: (String routeName, TopUpDpArguments args) =>
                this.push(context, routeName, args),
          ),
        );
      },
      SettingRoutes.topup_payment: (context) {
        final screenArgs = args as InquiryDetail;
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
      },
      SettingRoutes.verify_phone: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(
                ticker: Timer(),
              ),
            ),
            BlocProvider(
              create: (context) => SendChangeMobileBloc(
                changeMobileClient: ChangeMobileClient(),
                timerBloc: BlocProvider.of<TimerBloc>(context),
              ),
            ),
          ],
          child: VerifyPhone(),
        );
      }
    };
  }
}
