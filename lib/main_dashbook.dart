import 'package:flutter/material.dart';
import 'package:dashbook/dashbook.dart';

import 'package:darkpanda_flutter/components/stories/components.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/components/stories/stories.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/components/service_settings/stories/stories.dart';

void main() {
  final dashbook = Dashbook(
    usePreviewSafeArea: true,
  );

  appComponentsDashbook(dashbook);
  chatroomInquiryStories(dashbook);
  serviceSettingsComponentsDashbook(dashbook);

  runApp(dashbook);
}
