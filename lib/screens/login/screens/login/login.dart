import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/screens/register/auth_navigator.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/layouts/system_ui_overlay_layout.dart';

import '../../bloc/send_login_verify_code_bloc.dart';
import '../../screen_arguments/args.dart';

part 'components/login_form.dart';

// @ref SystemUiOverlayStyle setting is referenced from:
//   - https://api.flutter.dev/flutter/services/SystemChrome/setSystemUIOverlayStyle.html
//   - https://www.youtube.com/watch?v=PqZgkU_SZAE&ab_channel=LirsTechTips
class Login extends StatefulWidget {
  const Login({
    this.onPush,
  });

  final Function(String, VerifyLoginPinArguments) onPush;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = '';

  Widget _buildLogoImage() {
    return Row(
      children: [
        Container(
          child: Image(
            image: AssetImage('assets/logo.png'),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  Widget _buildTitleText() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '歡迎來到 Dark Panda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SystemUiOverlayLayout(
        child: Container(
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 92),
                  _buildLogoImage(),
                  SizedBox(height: 26),
                  _buildTitleText(),
                  SizedBox(height: 30),
                  BlocListener<SendLoginVerifyCodeBloc,
                      SendLoginVerifyCodeState>(
                    listener: (context, state) {
                      // User send his / her first login verify code on login page
                      // which means the user should have numSend equals 0.
                      if (state.status == AsyncLoadingStatus.done &&
                          state.numSend == 1) {
                        widget.onPush(
                          '/login/verify-login-ping',
                          VerifyLoginPinArguments(
                            verifyPrefix: state.verifyChar,
                            uuid: state.uuid,
                            mobile: state.mobile,
                            username: _username,
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<SendLoginVerifyCodeBloc,
                        SendLoginVerifyCodeState>(
                      builder: (context, state) {
                        return LoginForm(
                          loading: state.status == AsyncLoadingStatus.loading,
                          formKey: _formKey,
                          onLogin: (String username) {
                            setState(() {
                              _username = username;
                            });

                            // send login verify code
                            BlocProvider.of<SendLoginVerifyCodeBloc>(context)
                                .add(
                              SendLoginVerifyCodeResetNumSend(
                                username: username,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  /// Use [Expanded] to fill up the rest of the column space
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 44,
                        child: DPTextButton(
                          theme: DPTextButtonThemes.purple,
                          onPressed: () {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              MaterialPageRoute(
                                builder: (context) => AuthNavigator(),
                              ),
                            );
                          },
                          text: AppLocalizations.of(context).register,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
