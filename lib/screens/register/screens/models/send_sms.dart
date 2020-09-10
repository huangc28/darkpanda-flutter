class SendSMS {
  final String uuid;
  final String verifyPrefix;

  SendSMS({
    this.uuid,
    this.verifyPrefix,
  });

  static SendSMS fromJson(Map<String, dynamic> data) {
    return SendSMS(
      uuid: data['uuid'],
      verifyPrefix: data['verify_prefix'],
    );
  }
}
