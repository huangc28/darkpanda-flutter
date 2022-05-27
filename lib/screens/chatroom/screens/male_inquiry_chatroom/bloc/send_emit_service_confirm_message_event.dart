part of 'send_emit_service_confirm_message_bloc.dart';

abstract class SendEmitServiceConfirmMessageEvent extends Equatable {
  const SendEmitServiceConfirmMessageEvent();

  @override
  List<Object> get props => [];
}

class EmitServiceConfirmMessage extends SendEmitServiceConfirmMessageEvent {
  const EmitServiceConfirmMessage(this.serviceUuid);

  final String serviceUuid;

  @override
  List<Object> get props => [this.serviceUuid];
}
