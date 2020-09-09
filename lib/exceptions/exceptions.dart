class AppBaseException implements Exception {
  final String message;
  final String code;

  AppBaseException({this.message, this.code});
}

class APIException extends AppBaseException {
  final String message;
  final String code;

  APIException({
    this.message,
    this.code,
  }) : super(
          message: message,
          code: code,
        );

  static APIException fromJson(Map<String, dynamic> data) {
    return APIException(
      message: data['err_msg'],
      code: data['err_code'],
    );
  }
}

class AppGeneralExeption extends AppBaseException {
  final String message;
  AppGeneralExeption({this.message}) : super(message: message);
}
