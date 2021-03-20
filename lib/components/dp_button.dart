import 'package:flutter/material.dart';

enum DPTextButtonThemes {
  pink,
  purple,
  disable,
}

class ThemeConfig {
  final Color backgroundColor;

  const ThemeConfig._({
    this.backgroundColor,
  });

  const ThemeConfig.setConfig({
    Color backgroundColor,
    TextStyle textStyle,
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
  DPTextButtonThemes.disable: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(255, 255, 255, 0.18),
  )
};

class DPTextButton extends StatefulWidget {
  const DPTextButton({
    Key key,
    this.theme = DPTextButtonThemes.pink,
    this.disabled = false,
    this.text = '',
    this.child,
    @required this.onPressed,
  }) : super(key: key);

  final bool disabled;
  final DPTextButtonThemes theme;
  final Widget child;
  final Function onPressed;
  final String text;

  @override
  _DPTextButtonState createState() => _DPTextButtonState();
}

class _DPTextButtonState extends State<DPTextButton> {
  @override
  Widget build(BuildContext context) {
    var chosenTheme = widget.disabled
        ? themes[DPTextButtonThemes.disable]
        : themes[widget.theme];

    print('DEBUG chosenTheme ${chosenTheme.backgroundColor}');

    return TextButton(
      onPressed: widget.disabled ? null : widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: widget.disabled
                ? Color.fromRGBO(106, 109, 137, 1)
                : Colors.white,
          ),
        ),
      ),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
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
