import 'package:country_code_picker/country_code_picker.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/screens/register/services/util.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumController = TextEditingController();

  String _mobileNumber;
  String _dialCode = '+886';
  bool _disableSend = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Text(
                  '輸入你的電話號碼',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 11),
                Text(
                  '驗證碼會寄至您的手機',
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
                SizedBox(height: 20),
                DPTextButton(
                  theme: DPTextButtonThemes.purple,
                  onPressed: () {},
                  text: '發送驗證碼',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // Padding(
    //   padding: EdgeInsets.all(20.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Text(
    //         '請輸入您的新號碼',
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 16,
    //         ),
    //       ),
    //       Text(
    //         '我們會寄驗證碼到你的手機',
    //         style: TextStyle(
    //           color: Color.fromRGBO(106, 109, 137, 1),
    //           fontSize: 15,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
