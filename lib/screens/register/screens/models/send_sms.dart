class SendSMS {
  final String uuid;
  final String verifyPrefix;
  final int verifySuffix;

  SendSMS({
    this.uuid,
    this.verifyPrefix,
    this.verifySuffix,
  });

  static SendSMS fromJson(Map<String, dynamic> data) {
    return SendSMS(
      uuid: data['uuid'],
      verifyPrefix: data['verify_prefix'],
      verifySuffix: data['verify_suffix'],
    );
  }
}
