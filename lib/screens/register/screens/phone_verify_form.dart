import 'package:flutter/material.dart';

import './models/models.dart' as models;

class PhoneVerifyForm extends StatefulWidget {
  @override
  _PhoneVerifyFormState createState() => _PhoneVerifyFormState();
}

class _PhoneVerifyFormState extends State<PhoneVerifyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _countryCodes = ['+886'];
  final models.PhoneVerifyFormModel _formModel = models.PhoneVerifyFormModel();

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
          ),
        ),
      ],
    );
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
        ],
      ),
    );
  }
}
