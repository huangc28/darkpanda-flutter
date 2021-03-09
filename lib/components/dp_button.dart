import 'package:flutter/material.dart';

class DPTextButton extends StatelessWidget {
  const DPTextButton({
    Key key,
    this.backgroundColor,
    @required this.child,
    @required this.onPress,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget child;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
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
          backgroundColor,
        ),
      ),
    );
  }
}
