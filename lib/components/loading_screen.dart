import 'package:flutter/material.dart';

import './loading_icon.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Center(
          child: LoadingIcon(),
        ),
      ),
    );
  }
}
