class Error {
  final String message;
  final String code;

  Error({
    this.message,
    this.code,
  });

  static Error fromJson(Map<String, dynamic> data) {
    return Error(
      message: data['err_msg'],
      code: data['err_code'],
    );
  }
}
