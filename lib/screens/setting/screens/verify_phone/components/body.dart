//  3rd party
import 'package:country_code_picker/country_code_picker.dart';
import 'package:darkpanda_flutter/bloc/timer_bloc.dart';
import 'package:darkpanda_flutter/components/loading_screen.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/pkg/timer.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/bloc/send_change_mobile_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/bloc/verify_change_mobile_bloc.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/screen_arguments/verify_change_mobile_arguments.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/screens/verify_new_phone_code/verify_new_phone_code.dart';
import 'package:darkpanda_flutter/screens/setting/screens/verify_phone/services/change_mobile_apis.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';

// project dependencies
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/screens/register/services/util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formVerifyKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumController = TextEditingController();

  String _mobileNumber;
  String _dialCode = '+886';
  bool _disableSend = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Form(
              key: _formVerifyKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    '請輸入你的新號碼',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 11),
                  Text(
                    '我們會寄驗證碼到你的手機',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 0.47,
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),
                  ),
                  SizedBox(height: 26),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CountryCodePicker(
                        onChanged: (CountryCode code) {
                          setState(() {
                            _dialCode = code.dialCode;
                          });
                        },
                        initialSelection: 'TW',
                        favorite: ['+886', 'TW'],
                        countryFilter: ['TW'],
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        showCountryOnly: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 2),
                      // Mobile number text input
                      Expanded(
                        child: DPTextFormField(
                          keyboardType: TextInputType.phone,
                          hintText: '輸入電話號碼',
                          controller: _mobileNumController,
                          validator: (String v) {
                            // Makesure the phone number input is are all number
                            if (!Util.isNumeric(v)) {
                              return '電話號碼必須是數字';
                            }
                            return null;
                          },
                          onChanged: (String v) {
                            // Enable send button when input field is not an empty string
                            if (v != null && v.isNotEmpty) {
                              setState(() {
                                _disableSend = false;
                              });
                            } else {
                              setState(() {
                                _disableSend = true;
                              });
                            }
                          },
                          onSaved: (String v) {
                            _mobileNumber = v;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.07,
                  ),
                  BlocListener<SendChangeMobileBloc, SendChangeMobileState>(
                    listener: (context, state) {
                      if (state.status == AsyncLoadingStatus.initial ||
                          state.status == AsyncLoadingStatus.loading) {
                        setState(() {
                          _isLoading = true;
                        });
                      }

                      if (state.status == AsyncLoadingStatus.error) {
                        print('sending sms error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error.message),
                          ),
                        );
                      }

                      if (state.status == AsyncLoadingStatus.done) {
                        setState(() {
                          _isLoading = false;
                        });
                        // Redirect to phone verify page
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => TimerBloc(
                                    ticker: Timer(),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => VerifyChangeMobileBloc(
                                    changeMobileClient: ChangeMobileClient(),
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => SendChangeMobileBloc(
                                    changeMobileClient: ChangeMobileClient(),
                                    timerBloc:
                                        BlocProvider.of<TimerBloc>(context),
                                  ),
                                ),
                              ],
                              child: VerifyNewPhoneCode(
                                args: VerifyChangeMobileArguments(
                                  dialCode: _dialCode,
                                  mobile: _mobileNumber,
                                  verifyChars: state
                                      .sendChangeMobileResponse.verifyPrefix,
                                ),
                              ),
                            );
                          }),
                        );
                      }
                    },
                    child: SizedBox(
                      height: SizeConfig.screenHeight * 0.065,
                      child: DPTextButton(
                        disabled: _disableSend,
                        theme: DPTextButtonThemes.purple,
                        text: '發送驗證碼',
                        onPressed: () {
                          if (!_formVerifyKey.currentState.validate()) {
                            return;
                          }

                          _formVerifyKey.currentState.save();

                          BlocProvider.of<SendChangeMobileBloc>(context).add(
                            SendChangeMobile(_dialCode + _mobileNumber),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                  ),
                  _isLoading
                      ? Row(
                          children: <Widget>[
                            LoadingScreen(),
                          ],
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
