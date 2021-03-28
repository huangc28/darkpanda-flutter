part of 'args.dart';

class VerifyLoginPinArguments {
  final String uuid;
  final String verifyPrefix;
  final String mobile;
  final String username;

  VerifyLoginPinArguments({
    this.verifyPrefix,
    this.uuid,
    this.mobile,
    this.username,
  });
}
