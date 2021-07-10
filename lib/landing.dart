import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'enums/gender.dart';
import 'package:darkpanda_flutter/routes.dart';

import 'package:darkpanda_flutter/screen_arguments/landing_screen_arguments.dart';

class Landing extends StatelessWidget {
  const Landing({
    this.args,
  });

  final LandingScreenArguments args;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (args.jwt == null || args.jwt.isEmpty) {
          Navigator.pushReplacementNamed(context, MainRoutes.login);
        } else {
          Navigator.pushReplacementNamed(
            context,
            args.gender == Gender.female.name
                ? MainRoutes.female
                : MainRoutes.male,
          );
        }
      },
    );

    return Container();
  }
}
