part of 'send_login_verify_code_bloc.dart';

class SendLoginVerifyCodeState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;

  /// Verify code prefix
  final String verifyChar;
  final String uuid;
  final String mobile;
  final E error;
  final int numSend;

  const SendLoginVerifyCodeState._({
    this.status,
    this.verifyChar,
    this.uuid,
    this.mobile,
    this.error,
    this.numSend,
  });

  SendLoginVerifyCodeState.initial(int numSend)
      : this._(
          status: AsyncLoadingStatus.initial,
          numSend: numSend,
        );

  SendLoginVerifyCodeState.sending(SendLoginVerifyCodeState m)
      : this._(
          status: AsyncLoadingStatus.loading,
          numSend: m.numSend,
        );

  SendLoginVerifyCodeState.sendFailed(SendLoginVerifyCodeState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
          numSend: m.numSend,
        );

  SendLoginVerifyCodeState.sendSuccess(SendLoginVerifyCodeState m)
      : this._(
          status: AsyncLoadingStatus.done,
          verifyChar: m.verifyChar,
          uuid: m.uuid,
          mobile: m.mobile,
          numSend: m.numSend,
        );

  SendLoginVerifyCodeState.resetNumSend(SendLoginVerifyCodeState m)
      : this._(
          status: m.status,
          verifyChar: m.verifyChar,
          uuid: m.uuid,
          mobile: m.mobile,
          numSend: 0,
        );

  factory SendLoginVerifyCodeState.copyFrom(
    SendLoginVerifyCodeState state, {
    String verifyChar,
    String uuid,
    String mobile,
    E error,
    int numSend,
  }) {
    return SendLoginVerifyCodeState._(
      verifyChar: verifyChar ?? state.verifyChar,
      uuid: uuid ?? state.uuid,
      mobile: mobile ?? state.mobile,
      error: error ?? state.error,
      numSend: numSend ?? state.numSend,
    );
  }

  @override
  List<Object> get props => [
        status,
        verifyChar,
        uuid,
        mobile,
        error,
        numSend,
      ];
}
