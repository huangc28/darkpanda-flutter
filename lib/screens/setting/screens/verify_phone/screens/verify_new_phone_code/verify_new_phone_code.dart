import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/screen_arguments/verify_change_mobile_arguments.dart';
import 'components/body.dart';

class VerifyNewPhoneCode extends StatefulWidget {
  const VerifyNewPhoneCode({
    Key key,
    this.args,
  }) : super(key: key);

  final VerifyChangeMobileArguments args;

  @override
  _VerifyNewPhoneCodeState createState() => _VerifyNewPhoneCodeState();
}

class _VerifyNewPhoneCodeState extends State<VerifyNewPhoneCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('電話認證'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: Body(
        args: widget.args,
      ),
    );
  }
}
