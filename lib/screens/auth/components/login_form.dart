import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    @required this.onSendVerifyCode,
  });

  final ValueChanged<String> onSendVerifyCode;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (String value) {
                if (value.trim().isEmpty) {
                  return 'Username is required';
                }

                return null;
              },
              onSaved: (String value) {
                _username = value;
              },
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  highlightedBorderColor: Colors.black,
                  onPressed: _submit,
                  child: const Text('Send Verify Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    widget.onSendVerifyCode(_username);
  }
}
