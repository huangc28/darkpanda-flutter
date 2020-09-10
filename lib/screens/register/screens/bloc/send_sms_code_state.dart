part of 'send_sms_code_bloc.dart';

enum SendSMSStatus {
  initial,
  sending,
  sendFailed,
  sendSuccess,
}

class SendSmsCodeState<E extends AppBaseException> extends Equatable {
  final E error;
  final models.SendSMS sendSMS;
  final SendSMSStatus status;

  const SendSmsCodeState._({
    this.status,
    this.error,
    this.sendSMS,
  });

  const SendSmsCodeState.initial()
      : this._(
          status: SendSMSStatus.initial,
        );

  const SendSmsCodeState.sending()
      : this._(
          status: SendSMSStatus.sending,
          error: null,
        );

  const SendSmsCodeState.sendFailed(E error)
      : this._(
          status: SendSMSStatus.sendFailed,
          error: error,
        );

  const SendSmsCodeState.sendSuccess(models.SendSMS sms)
      : this._(
          status: SendSMSStatus.sendSuccess,
          sendSMS: sms,
        );

  @override
  List<Object> get props => [status, error, sendSMS];
}
