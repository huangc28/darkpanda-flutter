part of 'send_message_bloc.dart';

class SendMessageEvent extends Equatable {
  const SendMessageEvent({
    this.content,
    this.channelUUID,
  });

  final String content;
  final String channelUUID;

  @override
  List<Object> get props => [];
}
