import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart' as models;
import '../bloc/register_bloc.dart';

enum Gender {
  male,
  female,
}

// @TODO
//   - field validation [ok]
//   - store field value in state widget [ok]
//   - emit form data to API [ok]
//   - display error message from backend if API gives failed response [ok]
//   - add loading icon when submitting register form [ok]
//   - remove error message when submitting register form [ok]
//   - store newly created user in state.
class RegisterForm extends StatefulWidget {
  final Function onRegister;

  RegisterForm({this.onRegister});

  @override
  _RegisterFormState createState() => _RegisterFormState(
        onRegister: onRegister,
      );
}

class _RegisterFormState extends State<RegisterForm> {
  var _genderLabelMap = {
    Gender.female.toString(): 'female',
    Gender.male.toString(): 'male',
  };

  final Function onRegister;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final models.RegisterForm _registerFromModel = models.RegisterForm();

  _RegisterFormState({this.onRegister});

  Widget _buildUsername() {
    return TextFormField(
      decoration: InputDecoration(hintText: 'Username'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _registerFromModel.username = value;
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
        _registerFromModel.gender = _genderLabelMap[Gender.female.toString()];
      },
      onSaved: (String value) {
        _registerFromModel.gender = _genderLabelMap[Gender.female.toString()];
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

        return null;
      },
      onSaved: (String value) {
        _registerFromModel.referalCode = value;
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
          SizedBox(height: 25.0),
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              if (state.status == RegisterStatus.registering) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[200]),
                );
              }

              String message =
                  (state.status == RegisterStatus.registerFailed) &&
                          state.error.message != null
                      ? state.error.message
                      : '';

              return Container(
                child: Text(message),
              );
            },
          ),
          SizedBox(height: 16.0),
          OutlineButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                _formKey.currentState.save();

                onRegister(_registerFromModel);
              })
        ],
      ),
    );
  }
}
