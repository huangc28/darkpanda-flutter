class SendChangeMobileResponse {
  SendChangeMobileResponse({this.verifyPrefix, this.mobile});

  String verifyPrefix;
  String mobile;

  SendChangeMobileResponse.fromMap(Map<String, dynamic> data)
      : verifyPrefix = data['verify_prefix'],
        mobile = data['mobile'];

  Map<String, dynamic> toMap() => {
        'verify_prefix': verifyPrefix,
        'mobile': mobile,
      };
}
