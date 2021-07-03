part of 'send_image_message_bloc.dart';

abstract class SendImageMessageEvent extends Equatable {
  const SendImageMessageEvent();

  @override
  List<Object> get props => [];
}

class SendImageMessage extends SendImageMessageEvent {
  const SendImageMessage({
    this.imageUrl,
    this.channelUUID,
  });

  final String imageUrl;
  final String channelUUID;

  @override
  List<Object> get props => [];
}
