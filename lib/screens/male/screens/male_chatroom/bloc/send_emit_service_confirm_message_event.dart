part of 'send_emit_service_confirm_message_bloc.dart';

abstract class SendEmitServiceConfirmMessageEvent extends Equatable {
  const SendEmitServiceConfirmMessageEvent();

  @override
  List<Object> get props => [];
}

class EmitServiceConfirmMessage extends SendEmitServiceConfirmMessageEvent {
  const EmitServiceConfirmMessage(this.inquiryUuid);

  final String inquiryUuid;

  @override
  List<Object> get props => [this.inquiryUuid];
}
