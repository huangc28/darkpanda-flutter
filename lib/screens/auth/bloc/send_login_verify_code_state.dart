part of 'send_login_verify_code_bloc.dart';

enum SendLoginVerifyCodeStatus {
  initial,
  sending,
  sendFailed,
  sendSuccess,
}

class SendLoginVerifyCodeState<E extends AppBaseException> extends Equatable {
  final SendLoginVerifyCodeStatus status;

  /// Verify code prefix
  final String verifyChar;
  final String uuid;
  final String mobile;
  final E error;

  const SendLoginVerifyCodeState._({
    this.status,
    this.verifyChar,
    this.uuid,
    this.mobile,
    this.error,
  });

  const SendLoginVerifyCodeState.initial()
      : this._(
          status: SendLoginVerifyCodeStatus.initial,
        );

  const SendLoginVerifyCodeState.sending()
      : this._(
          status: SendLoginVerifyCodeStatus.sending,
        );

  const SendLoginVerifyCodeState.sendFailed({
    E error,
  }) : this._(
          status: SendLoginVerifyCodeStatus.sendFailed,
          error: error,
        );

  const SendLoginVerifyCodeState.sendSuccess(
    SendLoginVerifyCodeState state, {
    @required String verifyChar,
    @required String uuid,
    @required String mobile,
  }) : this._(
          status: SendLoginVerifyCodeStatus.sendSuccess,
          verifyChar: verifyChar,
          uuid: uuid,
          mobile: mobile,
        );

  @override
  List<Object> get props => [
        status,
        verifyChar,
        uuid,
        mobile,
      ];
}
