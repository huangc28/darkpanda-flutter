import 'package:flutter/material.dart';

import 'bloc/submit.dart';

enum Gender {
  male,
  female,
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

// @TODO
//   - field validation [ok]
//   - store field value in state widget [ok]
//   - emit form data to API.
class _RegisterFormState extends State<RegisterForm> {
  String _username = '';
  String _gender = Gender.female.toString();
  String _referalCode = '';

  var _genderLabelMap = {
    Gender.female.toString(): 'female',
    Gender.male.toString(): 'male',
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _bloc = SubmitBloc();

  Widget _buildUsername() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Username'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }
      },
      onSaved: (String value) {
        print('trigger onsave username $value');
        _username = value;
      },
    );
  }

  Widget _buildGender() {
    return DropdownButtonFormField<String>(
      value: Gender.female.toString(),
      items: [
        Gender.female.toString(),
        Gender.male.toString(),
      ]
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(_genderLabelMap[value]),
              ))
          .toList(),
      onChanged: (String value) {
        _gender = value;
      },
    );
  }

  Widget _buildReferalCode() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Referal Code'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Referal code is required';
        }
      },
      onSaved: (String value) {
        print('trigger onsave referal code $value');
        _referalCode = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildUsername(),
          _buildGender(),
          _buildReferalCode(),
          SizedBox(height: 50.0),
          RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                _formKey.currentState.save();

                print('DEBUG $_username $_gender $_referalCode');
                _bloc.registerSink.add(RegisterEvent(
                  username: _username,
                  gender: _gender,
                  referalCode: _referalCode,
                ));
              })
        ],
      ),
    );
  }
}
