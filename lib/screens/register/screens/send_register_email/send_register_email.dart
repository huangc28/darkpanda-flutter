import 'package:flutter/material.dart';

import 'components/body.dart';

class SendRegisterEmail extends StatefulWidget {
  const SendRegisterEmail({Key key}) : super(key: key);

  @override
  _SendRegisterEmailState createState() => _SendRegisterEmailState();
}

class _SendRegisterEmailState extends State<SendRegisterEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
