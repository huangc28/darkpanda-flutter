import 'package:flutter/material.dart';
// import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pinput.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

class DPPinPut extends StatelessWidget {
  const DPPinPut({
    Key key,
    this.onSubmit,
    this.onSaved,
    this.validator,
    this.controller,
    @required this.fieldsCount,
  }) : super(key: key);

  final ValueChanged<String> onSubmit;
  final ValueChanged<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final int fieldsCount;

  @override
  Widget build(BuildContext context) {
    //final BoxDecoration pinputDecoration = BoxDecoration(
    //  color: Color.fromRGBO(255, 255, 255, 0.1),
    //  borderRadius: BorderRadius.circular(8),
    //);

    final defaultPinTheme = PinTheme(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(
        fontSize: 15,
        letterSpacing: 0.47,
      ),
    );

    final focusedPinTheme = PinTheme();
    final errorPinTheme = PinTheme(
      textStyle: TextStyle(fontSize: 15, letterSpacing: 0.47),
    );

    return Pinput(
      length: 4,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      errorPinTheme: errorPinTheme,
    );

    //return Pinput(
    //  inputDecoration: InputDecoration(
    //    errorStyle: TextStyle(
    //      fontSize: 15,
    //      letterSpacing: 0.47,
    //    ),
    //    focusedErrorBorder: InputBorder.none,
    //    errorBorder: InputBorder.none,
    //    border: InputBorder.none,
    //  ),
    //  onSubmit: onSubmit,
    //  onSaved: onSaved,
    //  validator: validator,
    //  controller: controller,
    //  keyboardType: TextInputType.number,
    //  fieldsCount: fieldsCount,
    //  textStyle: TextStyle(
    //    color: Colors.white,
    //    fontSize: 30,
    //  ),
    //  submittedFieldDecoration: pinputDecoration,
    //  selectedFieldDecoration: pinputDecoration,
    //  followingFieldDecoration: pinputDecoration,
    //  eachFieldWidth: SizeConfig.screenWidth * 0.12, //50
    //  eachFieldHeight: SizeConfig.screenHeight * 0.065, //57
    // );
  }
}
