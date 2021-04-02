import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum DPTextButtonThemes {
  pink,
  purple,
  grey,
  lightGrey,
  disable,
}

class ThemeConfig {
  final Color backgroundColor;
  final TextStyle textStyle;

  const ThemeConfig._({
    this.backgroundColor,
    this.textStyle,
  });

  const ThemeConfig.setConfig({
    Color backgroundColor,
    TextStyle textStyle,
  }) : this._(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
        );
}

final baseButtonTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);

Map<DPTextButtonThemes, ThemeConfig> themes = {
  DPTextButtonThemes.pink: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(255, 64, 138, 1),
    textStyle: baseButtonTextStyle,
  ),
  DPTextButtonThemes.purple: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(119, 81, 255, 1),
    textStyle: baseButtonTextStyle,
  ),
  DPTextButtonThemes.lightGrey: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(203, 205, 214, 1),
    textStyle: baseButtonTextStyle.copyWith(
      color: Color.fromRGBO(31, 30, 56, 1),
    ),
  ),
  DPTextButtonThemes.grey: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(106, 109, 137, 1),
    textStyle: baseButtonTextStyle,
  ),
  DPTextButtonThemes.disable: ThemeConfig.setConfig(
    backgroundColor: Color.fromRGBO(255, 255, 255, 0.18),
    textStyle: baseButtonTextStyle.copyWith(
      color: Color.fromRGBO(106, 109, 137, 1),
    ),
  )
};

class DPTextButton extends StatefulWidget {
  const DPTextButton({
    Key key,
    this.theme = DPTextButtonThemes.pink,
    this.disabled = false,
    this.text = '',
    this.loading = false,
    this.icon = null,
    @required this.onPressed,
  }) : super(key: key);

  final bool disabled;
  final bool loading;
  final DPTextButtonThemes theme;
  final String text;
  final Icon icon;
  final Function onPressed;

  @override
  _DPTextButtonState createState() => _DPTextButtonState();
}

class _DPTextButtonState extends State<DPTextButton> {
  Widget _buildText(ThemeConfig themeConf) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: themeConf.textStyle,
        ),
        widget.icon == null
            ? Container()
            : Padding(
                padding: EdgeInsets.only(left: 4),
                child: widget.icon,
              ),
      ],
    );
  }

  Widget _buildSpinner() {
    return Container(
      height: 30.0,
      child: SpinKitCircle(
        color: Colors.white,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var chosenTheme = widget.disabled
        ? themes[DPTextButtonThemes.disable]
        : themes[widget.theme];

    return TextButton(
      onPressed: widget.disabled ? null : widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        child:
            widget.loading == false ? _buildText(chosenTheme) : _buildSpinner(),
      ),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          chosenTheme.textStyle,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28.0),
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          chosenTheme.backgroundColor,
        ),
      ),
    );
  }
}
