part of 'args.dart';

class VerifyLoginPinArguments {
  final String uuid;
  final String verifyPrefix;
  final String mobile;

  VerifyLoginPinArguments({
    this.verifyPrefix,
    this.uuid,
    this.mobile,
  });
}
