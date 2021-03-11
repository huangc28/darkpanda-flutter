import 'package:flutter/material.dart';

enum DPTextButtonThemes {
  pink,
  purple,
}

class ThemeConfig {
  final Color backgroundColor;
  const ThemeConfig._({
    this.backgroundColor,
  });

  const ThemeConfig.setConfig({
    Color backgroundColor,
  }) : this._(
          backgroundColor: backgroundColor,
        );
}

Map<DPTextButtonThemes, ThemeConfig> themes = {
  DPTextButtonThemes.pink: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(255, 64, 138, 1),
  ),
  DPTextButtonThemes.purple: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(119, 81, 255, 1),
  ),
};

class DPTextButton extends StatelessWidget {
  const DPTextButton({
    Key key,
    this.theme = DPTextButtonThemes.pink,
    @required this.child,
    @required this.onPress,
  }) : super(key: key);

  final DPTextButtonThemes theme;
  final Widget child;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    var chosenTheme = themes[theme];

    return TextButton(
      onPressed: onPress,
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28.0),
            ),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.fromLTRB(0, 15, 0, 15),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          chosenTheme.backgroundColor,
        ),
      ),
    );
  }
}
