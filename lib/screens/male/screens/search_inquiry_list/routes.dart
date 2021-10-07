import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screen_arguments/args.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_historical_services_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/bloc/load_user_images_bloc.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_list/screens/inquirer_profile/inquirer_profile.dart';
import 'package:darkpanda_flutter/screens/male/bloc/agree_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/search_inquiry_list.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/load_rate_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/services/rate_api_client.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_dp_package_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/screen_arguements/topup_dp_arguements.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/topup_dp.dart';
import 'package:darkpanda_flutter/services/user_apis.dart';

import '../male_chatroom/bloc/disagree_inquiry_bloc.dart';
import '../male_chatroom/bloc/exit_chatroom_bloc.dart';
import 'screens/search_inquiry/screens/inquiry_form/inquiry_form.dart';
import 'screens/search_inquiry/search_inquiry.dart';

class SearchInquiryRoutes extends BaseRoutes {
  static const root = '/';
  static const randomSearch = '/random-search';
  static const inquiry_form = '/inquiry-form';
  static const inquirerProfile = '/inquirer-profile';
  static const topup_dp = '/topup-dp';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SearchInquiryRoutes.root: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                  loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
                ),
              ),
            ],
            child: SearchInquiryList(),
          ),
      SearchInquiryRoutes.randomSearch: (contect) => MultiProvider(
            providers: [
              BlocProvider(
                create: (context) => LoadInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                  loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
                ),
              ),
              BlocProvider(
                create: (context) => AgreeInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                  inquiryChatroomsBloc:
                      BlocProvider.of<InquiryChatroomsBloc>(context),
                ),
              ),
              BlocProvider(
                create: (context) => CancelInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                  loadInquiryBloc: LoadInquiryBloc(),
                ),
              ),
              BlocProvider(
                create: (context) => ExitChatroomBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                  inquiryChatroomsBloc:
                      BlocProvider.of<InquiryChatroomsBloc>(context),
                ),
              ),
              BlocProvider(
                create: (context) => DisagreeInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                ),
              ),
            ],
            child: SearchInquiry(
              onPush: (String routeName, InquirerProfileArguments args) =>
                  this.push(context, routeName, args),
            ),
          ),
      SearchInquiryRoutes.inquiry_form: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoadInquiryBloc(
                searchInquiryAPIs: SearchInquiryAPIs(),
              ),
            ),
            BlocProvider(
              create: (context) => SearchInquiryFormBloc(
                searchInquiryAPIs: SearchInquiryAPIs(),
                loadInquiryBloc: BlocProvider.of<LoadInquiryBloc>(context),
              ),
            ),
            BlocProvider(
              create: (context) => LoadServiceListBloc(
                searchInquiryAPIs: SearchInquiryAPIs(),
              ),
            ),
          ],
          child: InquiryForm(
            onPush: (String routeName) => this.push(context, routeName, args),
          ),
        );
      },
      SearchInquiryRoutes.inquirerProfile: (context) {
        final screenArgs = args as InquirerProfileArguments;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoadUserImagesBloc(
                userApi: UserApis(),
              ),
            ),
            BlocProvider(
              create: (context) => LoadHistoricalServicesBloc(
                userApi: UserApis(),
              ),
            ),
            BlocProvider(
              create: (context) => LoadRateBloc(
                rateApiClient: RateApiClient(),
              ),
            ),
          ],
          child: InquirerProfile(
            loadUserBloc: BlocProvider.of<LoadUserBloc>(context),
            args: screenArgs,
          ),
        );
      },
      SearchInquiryRoutes.topup_dp: (context) {
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
    };
  }
}
