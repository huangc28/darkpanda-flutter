import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static final SecureStore _secureStore =
      new SecureStore._internal(fsc: new FlutterSecureStorage());
  FlutterSecureStorage fsc;

  factory SecureStore() {
    return _secureStore;
  }

  SecureStore._internal({this.fsc});
}
