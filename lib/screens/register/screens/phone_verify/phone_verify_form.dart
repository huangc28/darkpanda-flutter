import 'package:flutter/material.dart';

import '../models/models.dart' as models;

// @TODOs
//   - Instruct backend to send verify code via SMS.
//   - Mobile number value validation.
//   - Provide a `onVerify` hook from parent widget.
class PhoneVerifyForm extends StatefulWidget {
  final Function onVerify;
  PhoneVerifyForm({@required this.onVerify});

  @override
  _PhoneVerifyFormState createState() => _PhoneVerifyFormState(
        onVerify: onVerify,
      );
}

class _PhoneVerifyFormState extends State<PhoneVerifyForm> {
  final Function onVerify;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// @TODO Retrieve list of country code from backend.
  final List<String> _countryCodes = ['+886'];
  final models.PhoneVerifyFormModel _formModel = models.PhoneVerifyFormModel();

  _PhoneVerifyFormState({@required this.onVerify});

  @override
  initState() {
    _formModel.countryCode = _countryCodes[0];
    super.initState();
  }

  Widget _buildPhoneFormField() {
    // - country code on the left, mobile number on the right
    // - country code options should be retrieved from backend.
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
        SizedBox(width: 20.0),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: InputDecoration(hintText: 'mobile number'),
            onSaved: (value) {
              _formModel.mobileNumber = value;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget _buildVerifyCodeInput() {
    return Text('testing');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Phone number',
          ),
          _buildPhoneFormField(),
          SizedBox(height: 25.0),
          _buildVerifyCodeInput(),
          SizedBox(height: 25.0),
          RaisedButton(
            child: Text(
              'Send',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return;
              }

              _formKey.currentState.save();

              onVerify(_formModel);
            },
          )
        ],
      ),
    );
  }
}
