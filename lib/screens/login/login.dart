import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';

import 'components/login_form.dart';

// @ref SystemUiOverlayStyle setting is referenced from:
//   - https://api.flutter.dev/flutter/services/SystemChrome/setSystemUIOverlayStyle.html
//   - https://www.youtube.com/watch?v=PqZgkU_SZAE&ab_channel=LirsTechTips
class Login extends StatelessWidget {
  const Login();

  Widget _buildLogoImage() {
    return Row(
      children: [
        Container(
          child: Image(
            image: AssetImage('assets/auth/logo.png'),
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
              LoginForm(),

              /// Use [Expanded] to fill up the rest of the column space
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DPTextButton(
                    backgroundColor: Color.fromRGBO(119, 81, 255, 1),
                    onPress: () {
                      print('onRegister');
                    },
                    child: Text(
                      '註冊',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/auth/login_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
