import 'package:flutter/material.dart';

class UnfocusPrimary extends StatelessWidget {
  const UnfocusPrimary({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}
