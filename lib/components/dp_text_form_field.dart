import 'package:flutter/material.dart';

enum DPTextFieldThemes {
  transparent,
  white,
}

class ThemeConfig {
  final InputDecoration decoration;
  final TextStyle style;

  const ThemeConfig._({
    this.decoration,
    this.style,
  });
  const ThemeConfig.setConfig({
    InputDecoration decoration,
    TextStyle style,
  }) : this._(
          decoration: decoration,
          style: style,
        );
}

Map<DPTextFieldThemes, ThemeConfig> themes = {
  DPTextFieldThemes.white: ThemeConfig.setConfig(
    style: TextStyle(
      fontSize: 18,
      color: Colors.black,
      letterSpacing: .36,
    ),
    decoration: InputDecoration(
      helperText: ' ',
      errorStyle: TextStyle(
        fontSize: 15,
        letterSpacing: 0.47,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      fillColor: Colors.white,
      filled: true,
    ),
  ),
  DPTextFieldThemes.transparent: ThemeConfig.setConfig(
    style: TextStyle(
      fontSize: 18,
      color: Colors.white,
      letterSpacing: .36,
    ),
    decoration: InputDecoration(
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
  ),
};

class DPTextFormField extends StatelessWidget {
  const DPTextFormField({
    Key key,
    this.theme = DPTextFieldThemes.transparent,
    this.hintText = '',
    this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  final DPTextFieldThemes theme;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onSaved;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final chosenTheme = themes[theme];
    final textFieldDecoration = chosenTheme.decoration.copyWith(
      hintText: hintText,
    );

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      keyboardType: keyboardType,
      validator: validator,
      style: chosenTheme.style,
      decoration: textFieldDecoration,
    );
  }
}