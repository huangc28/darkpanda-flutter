import 'package:flutter/material.dart';

class DPTextFormField extends StatelessWidget {
  const DPTextFormField({
    Key key,
    this.hintText = '',
    this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onSaved;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        letterSpacing: .36,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color.fromRGBO(106, 109, 137, 1),
          fontSize: 15,
          letterSpacing: 1.5,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(26),
          ),
        ),
        errorStyle: TextStyle(
          fontSize: 15,
          letterSpacing: 0.47,
        ),
        focusedErrorBorder: InputBorder.none,
        errorBorder: InputBorder.none,
      ),
    );
  }
}
