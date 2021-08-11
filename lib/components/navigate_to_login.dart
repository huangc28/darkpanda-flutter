import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:darkpanda_flutter/pkg/secure_store.dart';
import 'package:darkpanda_flutter/main.dart';
import 'package:darkpanda_flutter/routes.dart';

class NavitgateToLogin extends StatelessWidget {
  clearToken() async {
    // Remove jwt token.
    await SecureStore().delJwtToken();

    // Remove gender.
    await SecureStore().delGender();
  }

  @override
  Widget build(BuildContext context) {
    clearToken();

    DarkPandaApp.valueNotifier.value = false;

    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainRoutes.login,
          (Route<dynamic> route) => false,
        );
      },
    );

    return Container();
  }
}
