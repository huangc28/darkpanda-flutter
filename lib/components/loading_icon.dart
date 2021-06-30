import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({
    Key key,
    this.color = Colors.white,
    this.size = 30,
  }) : super(key: key);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitCircle(
        color: color,
        size: size,
      ),
    );
  }
}
