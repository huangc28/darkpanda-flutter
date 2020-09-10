import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import '../models/models.dart' as models;

/// Data object to store verify code prefix and verify code suffix.
class VerifyCodeObject {
  String prefix;

  VerifyCodeObject({
    this.prefix: '',
  });
}

// @TODOs
//   - Instruct backend to send verify code via SMS. [ok]
//   - Mobile number value validation. [ok]
//   - Provide a `onVerify` hook from parent widget. [ok]
//   - Display verify code error. [ok]
//   - Display send SMS error. [ok]
//   - Implement resend button
//   - Redirect user to appropriate index page according to gender
class PhoneVerifyForm<Error extends AppBaseException> extends StatefulWidget {
  final Function onSendSMS;
  final Function onResendSMS;
  final Function onVerify;
  final bool hasSendSMS;
  final String verifyCodePrefix;
  final Error verifyCodeError;
  final Error sendSMSError;

  const PhoneVerifyForm({
    @required this.onSendSMS,
    @required this.onResendSMS,
    @required this.onVerify,
    this.hasSendSMS: false,
    this.verifyCodePrefix,
    this.verifyCodeError,
    this.sendSMSError,
  });

  @override
  _PhoneVerifyFormState createState() => _PhoneVerifyFormState(
        onVerify: onVerify,
        onSendSMS: onSendSMS,
        onResendSMS: onResendSMS,
        hasSendSMS: hasSendSMS,
        verifyCodeError: verifyCodeError,
        sendSMSError: sendSMSError,
      );
}

class _PhoneVerifyFormState<Error extends AppBaseException>
    extends State<PhoneVerifyForm> {
  final Function onVerify;
  final Function onSendSMS;
  final Function onResendSMS;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _editController = TextEditingController();

  /// @TODO Retrieve list of country code from backend.
  final List<String> _countryCodes = ['+886'];
  final models.PhoneVerifyFormModel _formModel = models.PhoneVerifyFormModel();

  String verifyCodePrefix;
  bool hasSendSMS;
  Error verifyCodeError;
  Error sendSMSError;

  _PhoneVerifyFormState({
    @required this.onVerify,
    @required this.onSendSMS,
    @required this.onResendSMS,
    this.hasSendSMS: false,
    this.verifyCodePrefix,
    this.verifyCodeError,
    this.sendSMSError,
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
    }

    if (verifyCodePrefix != widget.verifyCodePrefix) {
      verifyCodePrefix = widget.verifyCodePrefix;
      _editController.clear();
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
    return Column(
      children: [
        Container(
          child: sendSMSError != null ? Text(sendSMSError.message) : Text(''),
        ),
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

            onSendSMS(_formModel);
          },
        ),
      ],
    );
  }

  // display preffix and suffix in one row, deliminate it with hyphen.
  // show resend and verify button.
  Widget _buildVerifyCodeInput() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(verifyCodePrefix ?? ''),
        ),
        Expanded(
          flex: 1,
          child: Text('-'),
        ),
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: _editController,
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
              _formModel.prefix = verifyCodePrefix;
              _formModel.suffix = int.parse(value);
            },
          ),
        )
      ],
    );
  }

  Widget _buildVerifyCodeButtons() {
    return Column(
      children: [
        Container(
          child: verifyCodeError != null
              ? Text(verifyCodeError.message)
              : Text(''),
        ),
        SizedBox(height: 20),
        Row(
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
                onResendSMS(_formModel);
              },
            ),
            SizedBox(width: 20.0),
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
                onVerify(_formModel);
              },
            )
          ],
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