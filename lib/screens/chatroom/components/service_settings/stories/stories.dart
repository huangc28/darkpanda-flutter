import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import '../service_type_field.dart';

class BgColorDecorator extends Decorator {
  @override
  Widget decorate(Widget child) => Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: child,
      );
}

void serviceSettingsComponentsDashbook(Dashbook dashbook) {
  final serviceTypeCtrl = TextEditingController();

  serviceTypeCtrl.addListener(() {
    print('serviceTypeCtrl text ${serviceTypeCtrl.text}');
  });

  dashbook
      .storiesOf('service settings sheet')
      .decorator(CenterDecorator())
      .decorator(BgColorDecorator())
      .add(
        'service type field',
        (context) => ServiceTypeField(
          controller: serviceTypeCtrl,
          validator: (v) {
            print('DEBUG v ${v}');
          },
        ),
      );
}
