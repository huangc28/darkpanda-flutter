import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import '../models/models.dart' as models;

/// Data object to store verify code prefix and verify code suffix.
class VerifyCodeObject {
  String prefix;
  int suffix;

  VerifyCodeObject({
    this.prefix: '',
    this.suffix,
  });
}

// @TODOs
//   - Instruct backend to send verify code via SMS.
//   - Mobile number value validation.
//   - Provide a `onVerify` hook from parent widget.
class PhoneVerifyForm<Error extends Exception> extends StatefulWidget {
  final Function onVerify;
  final bool hasSendSMS;
  final VerifyCodeObject verifyCodeObj;
  final Error verifyCodeError;

  const PhoneVerifyForm({
    @required this.onVerify,
    this.hasSendSMS: false,
    this.verifyCodeObj,
    this.verifyCodeError,
  });

  @override
  _PhoneVerifyFormState createState() => _PhoneVerifyFormState(
        onVerify: onVerify,
        hasSendSMS: this.hasSendSMS,
      );
}

class _PhoneVerifyFormState<Error extends AppBaseException>
    extends State<PhoneVerifyForm> {
  final Function onVerify;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// @TODO Retrieve list of country code from backend.
  final List<String> _countryCodes = ['+886'];
  final models.PhoneVerifyFormModel _formModel = models.PhoneVerifyFormModel();

  bool hasSendSMS;
  VerifyCodeObject verifyCodeObj;
  Error verifyCodeError;

  _PhoneVerifyFormState({
    @required this.onVerify,
    this.hasSendSMS: false,
    this.verifyCodeObj,
    this.verifyCodeError,
  });

  @override
  initState() {
    _formModel.countryCode = _countryCodes[0];
    super.initState();
  }

  @override
  didUpdateWidget(old) {
    if (old.hasSendSMS != widget.hasSendSMS) {
      hasSendSMS = widget.hasSendSMS;
      verifyCodeObj = widget.verifyCodeObj;
    }

    if (old.verifyCodeError != widget.verifyCodeError) {
      verifyCodeError = widget.verifyCodeError;
    }

    super.didUpdateWidget(old);
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
    );
  }

  Widget _buildSendSMSButtons() {
    return RaisedButton(
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
    );
  }

  // display preffix and suffix in one row, deliminate it with hyphen.
  // show resend and verify button.
  Widget _buildVerifyCodeInput() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(verifyCodeObj.prefix),
        ),
        Expanded(
          flex: 1,
          child: Text('-'),
        ),
        Expanded(
          flex: 5,
          child: TextFormField(
            decoration: InputDecoration(hintText: 'verify code'),
            validator: (value) {
              if (value.isEmpty) {
                return 'verify code can\'t be empty';
              }

              final reg = RegExp(r'^\d{4}$');

              if (!reg.hasMatch(value)) {
                return 'must be 4 digit number';
              }

              return null;
            },
            onSaved: (value) {
              _formModel.prefix = verifyCodeObj.prefix;
              _formModel.suffix = int.parse(value);
            },
          ),
        )
      ],
    );
  }

  Widget _buildVerifyCodeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text(
            'Resend',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            print('DEBUG trigger resend');
          },
        ),
        SizedBox(width: 20.0),
        Container(
          child: Text(verifyCodeError.message),
        ),
        RaisedButton(
          child: Text(
            'Verify',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            // send verify code API
            print('DEBUG form key after saved ${_formModel.suffix}');
          },
        )
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
          SizedBox(height: 25.0),
          hasSendSMS
              ? _buildVerifyCodeInput()
              : Container(
                  height: 0,
                  width: 0,
                ),
          SizedBox(height: 25.0),
          hasSendSMS ? _buildVerifyCodeButtons() : _buildSendSMSButtons(),
        ],
      ),
    );
  }
}
