import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SecureStoreInheritedWidget inherit widget provides a singleton source of secure store instance
/// through out the application.
///
/// final storage = SecureStoreInheritedWidget.of(context)
/// storage.secureStorage.write(...)
class SecureStoreInheritedWidget extends InheritedWidget {
  final FlutterSecureStorage secureStorage;

  SecureStoreInheritedWidget({this.secureStorage, Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(SecureStoreInheritedWidget oldWidget) =>
      oldWidget.secureStorage != secureStorage;
}
