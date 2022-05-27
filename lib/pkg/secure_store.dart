import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const JwtTokenKey = 'jwt';
  static const GenderKey = 'gender';
  static const FcmTopicKey = 'fcm_topic';
  static const UuidKey = 'uuid';

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

  Future<void> delJwtToken() => fsc.delete(key: SecureStore.JwtTokenKey);

  // Store user gender
  Future<void> writeGender(String gender) => fsc.write(
        key: SecureStore.GenderKey,
        value: gender,
      );

  Future<String> readGender() => fsc.read(key: SecureStore.GenderKey);

  Future<void> delGender() => fsc.delete(key: SecureStore.GenderKey);

  // Store fcm topic
  Future<void> writeFcmTopic(String fcmTopic) => fsc.write(
        key: SecureStore.FcmTopicKey,
        value: fcmTopic,
      );

  Future<String> readFcmTopic() => fsc.read(key: SecureStore.FcmTopicKey);

  Future<void> delFcmTopic() => fsc.delete(key: SecureStore.FcmTopicKey);

  // Store fcm topic
  Future<void> writeUuid(String Uuid) => fsc.write(
        key: SecureStore.UuidKey,
        value: Uuid,
      );

  Future<String> readUuid() => fsc.read(key: SecureStore.UuidKey);

  Future<void> delUuid() => fsc.delete(key: SecureStore.UuidKey);
}
