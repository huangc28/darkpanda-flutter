import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: '請輸入您的用戶名',
            ),
          ),
          SizedBox(
            height: 26,
          ),
          DPTextButton(
            backgroundColor: Color.fromRGBO(255, 64, 138, 1),
            child: Text(
              '登錄',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            onPress: () {
              print('login');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '你的用戶名',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                wordSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 26,
        ),
        _buildForm(),
      ],
    );
  }
}
