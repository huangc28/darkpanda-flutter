part of 'send_login_verify_code_bloc.dart';

enum SendLoginVerifyCodeStatus {
  initial,
  sending,
  sendFailed,
  sendSuccess,
}

class SendLoginVerifyCodeState<E extends AppBaseException> extends Equatable {
  final SendLoginVerifyCodeStatus status;
  final String jwt;
  final E error;

  const SendLoginVerifyCodeState._({
    this.status,
    this.jwt,
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
    @required String jwt,
  }) : this._(
          status: SendLoginVerifyCodeStatus.sendSuccess,
          jwt: jwt,
        );

  @override
  List<Object> get props => [status, jwt];
}
