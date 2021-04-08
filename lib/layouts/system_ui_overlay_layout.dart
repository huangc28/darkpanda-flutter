import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiOverlayLayout extends StatelessWidget {
  const SystemUiOverlayLayout({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: child,
      value: SystemUiOverlayStyle.light,
    );
  }
}
