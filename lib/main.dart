import 'dart:async';

import 'package:darkpanda_flutter/screens/chatroom/bloc/send_update_inquiry_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/payment_complete_notifier_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/service_start_notifier_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/config.dart' as Config;
import 'package:darkpanda_flutter/services/user_apis.dart';
import 'package:darkpanda_flutter/services/inquiry_chatroom_apis.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/services/service_apis.dart';
import 'package:darkpanda_flutter/services/inquiry_apis.dart';

import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/services/register_api_client.dart';

import 'package:darkpanda_flutter/screens/chatroom/bloc/send_image_message_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/bloc/upload_image_message_bloc.dart';
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
import 'package:darkpanda_flutter/screen_arguments/landing_screen_arguments.dart';

import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/load_service_detail_bloc.dart';

import 'package:darkpanda_flutter/screens/service_list/bloc/load_incoming_service_bloc.dart';
import 'package:darkpanda_flutter/screens/service_list/services/service_chatroom_api.dart';

import './routes.dart';
import './theme.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';
import './bloc/auth_user_bloc.dart';

void main() async {
  // runZonedGuarded<Future<void>>(
  //   () async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_messageHandler);

  // Isolate.current.addErrorListener(RawReceivePort((pair) async {
  //   final List<dynamic> errorAndStacktrace = pair;
  //   await FirebaseCrashlytics.instance.recordError(
  //     errorAndStacktrace.first,
  //     errorAndStacktrace.last,
  //   );
  // }).sendPort);

  // Pass all uncaught errors from the framework to Crashlytics.
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Force disable Crashlytics collection while doing every day development.
  // Temporarily toggle this to true if you want to test crash reporting in your app.
  // await FirebaseCrashlytics.instance
  //     .setCrashlyticsCollectionEnabled(!kDebugMode);

  try {
    assert(app != null);

    // Initialize application config.
    await Config.AppConfig.initConfig();

    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    String _gender = await SecureStore().readGender();
    String _jwt = await SecureStore().readJwtToken();

    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://b4125f33e8e1468f921b6894d970ee50@o1018912.ingest.sentry.io/5984716';
      },
      appRunner: () => runApp(
        DarkPandaApp(
          gender: _gender,
          jwt: _jwt,
        ),
      ),
    );
  } catch (e, stackTrace) {
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
    );
  }
// await SentryFlutter.init(
//   (option) {
//     options.dsn = 'https://b4125f33e8e1468f921b6894d970ee50@o1018912.ingest.sentry.io/5984716';
//   }

// )
//   runApp(
//     DarkPandaApp(
//       gender: _gender,
//       jwt: _jwt,
//     ),
//   );
  // },
  //   FirebaseCrashlytics.instance.recordError,
  // );
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification?.body}');
}

class DarkPandaApp extends StatefulWidget {
  const DarkPandaApp({
    Key key,
    this.gender,
    this.jwt,
  }) : super(key: key);

  final String gender;
  final String jwt;
  static final ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);

  @override
  _DarkPandaAppState createState() => _DarkPandaAppState();
}

class _DarkPandaAppState extends State<DarkPandaApp> {
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

        BlocProvider(create: (context) => ServiceStartNotifierBloc()),

        BlocProvider(create: (context) => PaymentCompleteNotifierBloc()),

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
            serviceStartNotifierBloc:
                BlocProvider.of<ServiceStartNotifierBloc>(context),
            paymentCompleteNotifierBloc:
                BlocProvider.of<PaymentCompleteNotifierBloc>(context),
          ),
        ),

        BlocProvider(
          create: (_) => SendMessageBloc(
            inquiryChatroomApis: InquiryChatroomApis(),
          ),
        ),

        BlocProvider(
          create: (_) => SendUpdateInquiryMessageBloc(
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
          initialRoute: MainRoutes.landing,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                /// Media query initialization
                /// https://flutteragency.com/solve-mediaquery-of-called-with-a-context
                SizeConfig().init(context);

                if (settings.name == MainRoutes.landing) {
                  final LandingScreenArguments landingScreenArguments =
                      LandingScreenArguments(
                    gender: widget.gender,
                    jwt: widget.jwt,
                  );

                  final routeBuilder =
                      mainRoutes.routeBuilder(context, landingScreenArguments);

                  return routeBuilder[settings.name](context);
                }

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
