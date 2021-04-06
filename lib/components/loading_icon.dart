import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitCircle(
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
