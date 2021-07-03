import 'package:darkpanda_flutter/screens/chatroom/bloc/send_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/upload_image_message_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';
import 'package:darkpanda_flutter/services/inquiry_apis.dart';

import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/services/register_api_client.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/service_confirm_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/current_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/inquiry_chat_messages_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/current_service_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/send_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/get_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/update_inquiry_bloc.dart';

import 'package:darkpanda_flutter/bloc/load_user_bloc.dart';
import 'package:darkpanda_flutter/bloc/inquiry_chatrooms_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/current_service_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/disagree_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/exit_chatroom_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/send_emit_service_confirm_message_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/male_chatroom/bloc/update_inquitry_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/bloc/load_my_dp_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/topup_dp/services/apis.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/load_service_detail_bloc.dart';

import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/services/service_chatroom_api.dart';

import './routes.dart';
import './theme.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';
import './bloc/auth_user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);

  await DotEnv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    DarkPandaApp(),
  );
}

class DarkPandaApp extends StatelessWidget {
  DarkPandaApp();

  final mainRoutes = MainRoutes();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            registerAPI: RegisterAPIClient(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthUserBloc(
            dataProvider: UserApis(),
          ),
        ),

        BlocProvider(create: (context) => UpdateInquiryNotifierBloc()),

        BlocProvider(
          create: (context) => LoadMyDpBloc(
            apiClient: TopUpClient(),
          ),
        ),
        // Inquiry chatroom related blocs
        BlocProvider(create: (context) => InquiryChatMessagesBloc()),

        BlocProvider(
          create: (context) => InquiryChatroomsBloc(
            inquiryChatMesssagesBloc:
                BlocProvider.of<InquiryChatMessagesBloc>(context),
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),
        BlocProvider(
          create: (context) => LoadUserBloc(userApis: UserApis()),
        ),

        BlocProvider(
          create: (context) => LoadInquiryBloc(
            searchInquiryAPIs: SearchInquiryAPIs(),
          ),
        ),
        BlocProvider(
          create: (context) => CancelInquiryBloc(
            searchInquiryAPIs: SearchInquiryAPIs(),
            loadInquiryBloc: BlocProvider.of<LoadInquiryBloc>(context),
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
        BlocProvider(
          create: (context) => SendEmitServiceConfirmMessageBloc(
            searchInquiryAPIs: SearchInquiryAPIs(),
          ),
        ),

        // Current chatroom related blocs
        BlocProvider(
          create: (context) => CurrentServiceBloc(
            serviceApis: ServiceAPIs(),
          ),
        ),

        BlocProvider(create: (context) => ServiceConfirmNotifierBloc()),

        BlocProvider(
          create: (context) => CurrentChatroomBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
            userApis: UserApis(),
            inquiryChatroomsBloc:
                BlocProvider.of<InquiryChatroomsBloc>(context),
            currentServiceBloc: BlocProvider.of<CurrentServiceBloc>(context),
            serviceConfirmNotifierBloc:
                BlocProvider.of<ServiceConfirmNotifierBloc>(context),
            updateInquiryNotifierBloc:
                BlocProvider.of<UpdateInquiryNotifierBloc>(context),
          ),
        ),

        // Service chatroom
        BlocProvider(
          create: (context) => LoadIncomingServiceBloc(
            inquiryChatMesssagesBloc:
                BlocProvider.of<InquiryChatMessagesBloc>(context),
            apiClient: ServiceChatroomClient(),
          ),
        ),

        BlocProvider(
          create: (context) => LoadServiceDetailBloc(
            serviceAPIs: ServiceAPIs(),
          ),
        ),

        BlocProvider(
          create: (_) => SendImageMessageBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),

        BlocProvider(
          create: (_) => UploadImageMessageBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),

        BlocProvider(
          create: (context) => CurrentServiceChatroomBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
            userApis: UserApis(),
            loadIncomingServiceBloc:
                BlocProvider.of<LoadIncomingServiceBloc>(context),
            currentServiceBloc: BlocProvider.of<CurrentServiceBloc>(context),
            serviceConfirmNotifierBloc:
                BlocProvider.of<ServiceConfirmNotifierBloc>(context),
          ),
        ),

        BlocProvider(
          create: (_) => SendMessageBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),

        BlocProvider(
          create: (_) => GetInquiryBloc(
            inquiryApi: InquiryAPIClient(),
          ),
        ),

        BlocProvider(
          create: (_) => UpdateInquiryBloc(
            apis: InquiryAPIClient(),
          ),
        ),
      ],
      child: SecureStoreProvider(
        secureStorage: SecureStore().fsc,
        child: MaterialApp(
          /// Set the app language to be chinese TW.
          locale: Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW',
          ),

          /// CupertinoLocalization: https://github.com/flutter/flutter/issues/13452
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            CountryLocalizations.delegate,
            AppLocalizations.delegate,
          ],

          supportedLocales: [
            Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant',
              countryCode: 'TW',
            ),
            Locale.fromSubtags(languageCode: 'en'),
          ],

          theme: ThemeManager.getTheme(),
          initialRoute: MainRoutes.login,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                if (settings.name == MainRoutes.chatroom) {
                  final routeBuilder =
                      mainRoutes.routeBuilder(context, settings.arguments);

                  return routeBuilder[settings.name](context);
                }

                if (settings.name == MainRoutes.serviceChatroom) {
                  final routeBuilder =
                      mainRoutes.routeBuilder(context, settings.arguments);

                  return routeBuilder[settings.name](context);
                }

                if (settings.name == MainRoutes.maleChatroom) {
                  final routeBuilder =
                      mainRoutes.routeBuilder(context, settings.arguments);

                  return routeBuilder[settings.name](context);
                }

                if (settings.name == MainRoutes.male) {
                  final routeBuilder =
                      mainRoutes.routeBuilder(context, settings.arguments);

                  return routeBuilder[settings.name](context);
                }

                if (settings.name == MainRoutes.female) {
                  final routeBuilder =
                      mainRoutes.routeBuilder(context, settings.arguments);

                  return routeBuilder[settings.name](context);
                }

                return mainRoutes.routeBuilder(context)[settings.name](context);
              },
            );
          },
        ),
      ),
    );
  }
}
