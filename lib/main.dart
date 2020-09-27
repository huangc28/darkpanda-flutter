import 'package:flutter/material.dart';
import 'package:storyboard/storyboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/register/bloc/register_bloc.dart';
import 'package:darkpanda_flutter/screens/register/services/repository.dart';

import './theme.dart';
import './services/apis.dart';
import './pkg/secure_store.dart';
import './providers/secure_store.dart';

import './app.dart';

import './screens/auth/auth.dart';
import './screens/auth/bloc/send_login_verify_code_bloc.dart';
// import './screens/register/register.dart' as RegisterScreen;
// import './screens/register/screens/phone_verify/phone_verify.dart';
// import './screens/register/screens/phone_verify/services/data_provider.dart';

// import './screens/male/screens/search_inquiry/search_inquiry.dart';

import './pkg/timer.dart';
import './bloc/timer_bloc.dart';
import './bloc/auth_user_bloc.dart';
// import './screens/register/screens/phone_verify/bloc/mobile_verify_bloc.dart';
// import './screens/register/screens/phone_verify/bloc/send_sms_code_bloc.dart';

void main() {
  // runApp(StoryboardApp([]));

  runApp(DarkPandaApp());
}

class DarkPandaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            RegisterRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthUserBloc(
            dataProvider: UserApis(),
          ),
        ),
        BlocProvider(
          create: (context) => TimerBloc(
            ticker: Timer(),
          ),
        ),
        BlocProvider(
          create: (context) => SendLoginVerifyCodeBloc(),
        ),
      ],
      child: SecureStoreProvider(
        secureStorage: SecureStore().fsc,
        child: MaterialApp(
          theme: ThemeManager.getTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => Auth(),
            '/app': (context) => App(),
            //   '/': (context) => Home(),
            // '/register': (context) => RegisterScreen.Register(),
            //   '/register/verify-phone': (context) => MultiBlocProvider(
            //         providers: [
            //           BlocProvider(
            //               create: (context) => SendSmsCodeBloc(
            //                     dataProvider: PhoneVerifyDataProvider(),
            //                     timerBloc: BlocProvider.of<TimerBloc>(context),
            //                   )),
            //           BlocProvider(
            //               create: (context) => MobileVerifyBloc(
            //                     dataProvider: PhoneVerifyDataProvider(),
            //                     authUserBloc:
            //                         BlocProvider.of<AuthUserBloc>(context),
            //                   )),
            //         ],
            //         child: RegisterPhoneVerify(),
            //       ),

            //   // Routes of female users.
            //   '/female/inquiry': (context) {
            //     final _inquiriesBloc = InquiriesBloc(
            //       apiClient: inquiryApiClient.ApiClient(),
            //     );

            //     return MultiBlocProvider(
            //       providers: [
            //         BlocProvider<InquiriesBloc>(
            //           create: (context) {
            //             _inquiriesBloc.add(FetchInquiries(
            //               nextPage: 1,
            //             ));

            //             return _inquiriesBloc;
            //           },
            //         ),
            //         BlocProvider(
            //             create: (context) => LoadMoreInquiriesBloc(
            //                   inquiriesBloc: _inquiriesBloc,
            //                   apiClient: inquiryApiClient.ApiClient(),
            //                 ))
            //       ],
            //       child: InqiuryList(),
            //     );
            //   },
            //   // Routes of male users
            //   '/male/search_inquiry': (context) => SearchInqiury(),
            //   // '/inquiries/detail' () =>
          },
        ),
      ),
    );
  }
}
