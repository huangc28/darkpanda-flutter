import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    Key key,
    @required this.onLogin,
  }) : super(key: key);

  final ValueChanged<String> onLogin;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (String v) {
              // Username can not be empty
              if (v.trim().isEmpty) {
                return 'username is required';
              }

              return null;
            },
            onSaved: (String v) {
              _username = v;
            },
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
            text: '登錄',
            onPressed: _submit,
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

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    widget.onLogin(_username);
  }
}
