import 'package:dashbook/dashbook.dart';

import '../bullet.dart';

void appComponentsDashbook(Dashbook dashbook) {
  dashbook
      .storiesOf('Bullet')
      .decorator(CenterDecorator())
      .add('nickname bullet', (context) => Bullet('年齡'));
}
