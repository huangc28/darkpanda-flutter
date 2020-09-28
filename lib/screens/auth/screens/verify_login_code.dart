import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }

  return double.tryParse(s) != null;
}

class VerifyLoginCode extends StatefulWidget {
  const VerifyLoginCode();

  @override
  _VerifyLoginCodeState createState() => _VerifyLoginCodeState();
}

class _VerifyLoginCodeState extends State<VerifyLoginCode> {
  String _inputVerifyCode;

  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    _editController.addListener(_onChangePinCode);

    super.initState();
  }

  void _onChangePinCode() {
    // if the last character is digit, allow it to append
    // to the final value of the pin code
    final lastChar =
        _editController.text.substring(_editController.text.length - 1);

    if (!isNumeric(lastChar)) {
      _editController.value = TextEditingValue(
        text:
            _editController.text.substring(0, _editController.text.length - 1),
      );
    }
  }

  void dispose() {
    _editController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('verify login code'),
      ),
      body: Container(
        child: PinCodeTextField(
          controller: _editController,
          appContext: context,
          length: 4,
          onChanged: (String value) {
            print('DEBUG $value');
          },
          onCompleted: (String value) {},
          validator: (String value) {
            print('DEBUG validator $value');

            return null;
          },
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
