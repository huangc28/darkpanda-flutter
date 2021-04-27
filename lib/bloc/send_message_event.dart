part of 'send_message_bloc.dart';

abstract class SendMessageEvent extends Equatable {
  const SendMessageEvent();

  @override
  List<Object> get props => [];
}

class SendTextMessage extends SendMessageEvent {
  const SendTextMessage({
    this.content,
    this.channelUUID,
  });

  final String content;
  final String channelUUID;

  @override
  List<Object> get props => [];
}

/// If female user done editting service settings, send editted message to
/// the male user.
class SendServiceDetailConfirmMessage extends SendMessageEvent {
  const SendServiceDetailConfirmMessage({
    this.serviceSettings,
    this.inquiryUUID,
    this.channelUUID,
  })  : assert(serviceSettings != null),
        assert(inquiryUUID != null),
        assert(channelUUID != null);

  final ServiceSettings serviceSettings;
  final String inquiryUUID;
  final String channelUUID;
}

class SendUpdateInquiryMessage extends SendMessageEvent {
  const SendUpdateInquiryMessage({
    this.serviceSettings,
    this.inquiryUUID,
    this.channelUUID,
  })  : assert(serviceSettings != null),
        assert(inquiryUUID != null),
        assert(channelUUID != null);

  final ServiceSettings serviceSettings;
  final String inquiryUUID;
  final String channelUUID;
}
