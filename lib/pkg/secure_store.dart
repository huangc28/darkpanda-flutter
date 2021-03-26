import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const JwtTokenKey = 'jwt';

  static final SecureStore _secureStore =
      new SecureStore._internal(fsc: new FlutterSecureStorage());

  FlutterSecureStorage fsc;

  factory SecureStore() {
    return _secureStore;
  }

  SecureStore._internal({this.fsc});

  Future<void> writeJwtToken(String jwtToken) => fsc.write(
        key: SecureStore.JwtTokenKey,
        value: jwtToken,
      );

  Future<String> readJwtToken() => fsc.read(key: SecureStore.JwtTokenKey);
}
