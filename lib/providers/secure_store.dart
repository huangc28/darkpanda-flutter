import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SecureStoreInheritedWidget inherit widget provides a singleton source of secure store instance
/// through out the application.
///
/// final storage = SecureStoreInheritedWidget.of(context)
/// storage.secureStorage.write(...)
class SecureStoreProvider extends InheritedWidget {
  final FlutterSecureStorage secureStorage;

  SecureStoreProvider({
    this.secureStorage,
    Widget child,
  }) : super(child: child);

  static SecureStoreProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SecureStoreProvider>();
  }

  @override
  bool updateShouldNotify(SecureStoreProvider oldWidget) =>
      oldWidget.secureStorage != secureStorage;
}
