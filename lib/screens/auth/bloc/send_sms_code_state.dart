part of 'send_sms_code_bloc.dart';

class SendSmsCodeState<E extends AppBaseException> extends Equatable {
  final E error;
  final models.SendSMS sendSMS;
  final AsyncLoadingStatus status;
  final int numSend;

  const SendSmsCodeState._({
    this.status,
    this.error,
    this.sendSMS,
    this.numSend,
  });

  SendSmsCodeState.initial(int numSend)
      : this._(
          status: AsyncLoadingStatus.initial,
          error: null,
          numSend: numSend,
          sendSMS: null,
        );

  SendSmsCodeState.sending(SendSmsCodeState m)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: m.error,
          numSend: m.numSend,
          sendSMS: m.sendSMS,
        );

  SendSmsCodeState.sendFailed(SendSmsCodeState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
          numSend: m.numSend,
          sendSMS: m.sendSMS,
        );

  SendSmsCodeState.sendSuccess(SendSmsCodeState m)
      : this._(
          status: AsyncLoadingStatus.done,
          error: m.error,
          sendSMS: m.sendSMS,
          numSend: m.numSend,
        );

  factory SendSmsCodeState.copyFrom(
    SendSmsCodeState state, {
    E error,
    models.SendSMS sendSMS,
    int numSend,
  }) {
    return SendSmsCodeState._(
      error: error ?? state.error,
      sendSMS: sendSMS ?? state.sendSMS,
      numSend: numSend ?? state.numSend,
    );
  }

  @override
  List<Object> get props => [numSend, status, error, sendSMS];
}
