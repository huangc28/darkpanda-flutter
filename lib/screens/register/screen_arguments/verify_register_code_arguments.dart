part of 'args.dart';

class VerifyRegisterCodeArguments {
  VerifyRegisterCodeArguments({
    this.dialCode,
    this.mobile,
    this.verifyChars,
    this.uuid,
  });

  String dialCode;
  String mobile;
  String verifyChars;
  String uuid;
}
