import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart' as models;
import '../../../bloc/send_sms_code_bloc.dart';

part 'verify_buttons.dart';
part 'send_sms_buttons.dart';

// @TODOs
//   - Instruct backend to send verify code via SMS. [ok]
//   - Mobile number value validation. [ok]
//   - Provide a `onVerify` hook from parent widget. [ok]
//   - Display verify code error. [ok]
//   - Display send SMS error. [ok]
class SendPhoneVerifyCode<Error extends AppBaseException>
    extends StatefulWidget {
  const SendPhoneVerifyCode({
    this.onSend,
  });

  final Function onSend;

  @override
  _SendPhoneVerifyCodeState createState() => _SendPhoneVerifyCodeState();
}

class _SendPhoneVerifyCodeState<Error extends AppBaseException>
    extends State<SendPhoneVerifyCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// @TODO Retrieve list of country code from backend.
  final List<String> _countryCodes = ['+886'];
  final models.PhoneVerifyFormModel _formModel = models.PhoneVerifyFormModel();

  _SendPhoneVerifyCodeState();

  @override
  initState() {
    _formModel.countryCode = _countryCodes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              // Country code
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: _formModel.countryCode,
                  items: _countryCodes.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _formModel.countryCode = value;
                  },
                  onSaved: (value) {
                    _formModel.countryCode = value;
                  },
                ),
              ),

              SizedBox(width: 4),

              // Phone number field
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'mobile number'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'mobile number can\'t be empty';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    _formModel.mobileNumber = value;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          OutlineButton(
            child: Text(
              'Send',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }

              _formKey.currentState.save();

              widget.onSend(_formModel);
            },
          ),
        ],
      ),
    );
  }
}
