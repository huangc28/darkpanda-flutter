import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/register/screens/send_register_email/bloc/send_register_email_bloc.dart';
import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/exceptions/exceptions.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

import 'package:darkpanda_flutter/screens/register/components/step_bar_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState<Error extends AppBaseException> extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight * 0.02,
          vertical: 0,
        ),
        child: Column(
          children: <Widget>[
            StepBarImage(
              step: RegisterStep.StepThree,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenHeight * 0.02,
                    vertical: 0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _textLabel('建立你的電郵'),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        _textFormFieldEmail(),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        _textLabel('建立你的用戶名'),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        _textFormFieldUsername(),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        _textLabel('密碼'),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        _textFormFieldPassword(),
                        SizedBox(height: SizeConfig.screenHeight * 0.03),
                        _textLabel('確認密碼'),
                        SizedBox(height: SizeConfig.screenHeight * 0.02),
                        _textFormFieldConfirmPassword(),
                        SizedBox(height: SizeConfig.screenHeight * 0.06),
                        // Expanded(
                        //   child:
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: SizeConfig.screenHeight * 0.065,
                            child: DPTextButton(
                              theme: DPTextButtonThemes.purple,
                              onPressed: () {
                                /// Reset async error before performing validation
                                setState(() {
                                  // _verifyRefCodeErrStr = '';
                                  // _verifyUsernameErrStr = '';
                                });

                                /// verify pin code input and username synchronously
                                if (!_formKey.currentState.validate()) {
                                  return null;
                                }

                                _formKey.currentState.save();

                                /// verify email, username, password, confirm password validity asynchornously
                                BlocProvider.of<SendRegisterEmailBloc>(context)
                                    .add(
                                  SendRegister(
                                    email: _emailController.text,
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              },
                              text: '下一步',
                            ),
                          ),
                        ),
                        // ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFormFieldConfirmPassword() {
    return DPTextFormField(
      controller: _confirmPasswordController,
      hintText: '請輸入確認密碼',
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      onSaved: (String value) {},
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'confirm password can not be empty';
        }

        if (value.trim() != _passwordController.text) {
          return 'Confirm Pasword not match';
        }

        return null;
      },
      contentPadding: EdgeInsets.only(
        left: SizeConfig.screenHeight * 0.03, //14.0,
        bottom: SizeConfig.screenHeight * 0.01,
        top: SizeConfig.screenHeight * 0.01,
      ),
    );
  }

  Widget _textFormFieldPassword() {
    return DPTextFormField(
      controller: _passwordController,
      hintText: '請輸入密碼',
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      onSaved: (String v) {},
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'password can not be empty';
        }

        return null;
      },
      contentPadding: EdgeInsets.only(
        left: SizeConfig.screenHeight * 0.03, //14.0,
        bottom: SizeConfig.screenHeight * 0.01,
        top: SizeConfig.screenHeight * 0.01,
      ),
    );
  }

  Widget _textFormFieldUsername() {
    return DPTextFormField(
      controller: _usernameController,
      hintText: '請輸入你的用戶名',
      onSaved: (String value) {},
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'username can not be empty';
        }

        return null;
      },
      contentPadding: EdgeInsets.only(
        left: SizeConfig.screenHeight * 0.03, //14.0,
        bottom: SizeConfig.screenHeight * 0.01,
        top: SizeConfig.screenHeight * 0.01,
      ),
    );
  }

  Widget _textFormFieldEmail() {
    return DPTextFormField(
      controller: _emailController,
      hintText: '請輸入電郵',
      onSaved: (String value) {},
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'email can not be empty';
        }

        return null;
      },
      contentPadding: EdgeInsets.only(
        left: SizeConfig.screenHeight * 0.03, //14.0,
        bottom: SizeConfig.screenHeight * 0.01,
        top: SizeConfig.screenHeight * 0.01,
      ),
    );
  }

  Widget _textLabel(String value) {
    return Text(
      value,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}
