import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './slideup_provider.dart';

class SlideUpController {
  SlideUpController._private();

  static final SlideUpController instance = SlideUpController._private();
  factory SlideUpController() => instance;

  BuildContext providerContext;

  void toggle() {
    if (providerContext != null) {
      final provider = providerContext.read<SlideUpProvider>();
      provider.updateState(!provider.isShow);
    } else {
      print('Need init provider context');
    }
  }
}
