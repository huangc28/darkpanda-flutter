import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/screens/auth/auth_navigator.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 92, 30, 0),
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLogoImage(),
              SizedBox(height: 26),
              _buildTitleText(),
              SizedBox(height: 60),
              BlocListener<SendLoginVerifyCodeBloc, SendLoginVerifyCodeState>(
                listener: (context, state) {
                  if (state.status == AsyncLoadingStatus.done) {
                    widget.onPush(
                      '/login/verify-login-ping',
                      VerifyLoginPinArguments(
                        verifyPrefix: state.verifyChar,
                        uuid: state.uuid,
                        mobile: state.mobile,
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
                        // send login verify code
                        BlocProvider.of<SendLoginVerifyCodeBloc>(context).add(
                          SendLoginVerifyCode(
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
                    text: '註冊',
                  ),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
