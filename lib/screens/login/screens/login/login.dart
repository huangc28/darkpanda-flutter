import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/auth/auth_navigator.dart';

import 'components/login_form.dart';

import '../../bloc/send_login_verify_code_bloc.dart';

// @ref SystemUiOverlayStyle setting is referenced from:
//   - https://api.flutter.dev/flutter/services/SystemChrome/setSystemUIOverlayStyle.html
//   - https://www.youtube.com/watch?v=PqZgkU_SZAE&ab_channel=LirsTechTips
class Login extends StatelessWidget {
  const Login({
    this.onPush,
  });

  final ValueChanged<String> onPush;

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
                  if (state.status == SendLoginVerifyCodeStatus.sendFailed) {
                    print('send failed ${state.error.message}');
                  }
                },
                child: LoginForm(
                  onLogin: (String username) {
                    // send login verify code
                    BlocProvider.of<SendLoginVerifyCodeBloc>(context).add(
                      SendLoginVerifyCode(username: username),
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
