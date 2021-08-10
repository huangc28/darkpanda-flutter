part of 'send_update_inquiry_message_bloc.dart';

abstract class SendUpdateInquiryMessageEvent extends Equatable {
  const SendUpdateInquiryMessageEvent();

  @override
  List<Object> get props => [];
}

/// If female user done editting service settings, send editted message to
/// the male user.
class SendServiceDetailConfirmMessage extends SendUpdateInquiryMessageEvent {
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

class SendUpdateInquiryMessage extends SendUpdateInquiryMessageEvent {
  const SendUpdateInquiryMessage({
    this.serviceSettings,
    this.channelUUID,
  })  : assert(serviceSettings != null),
        assert(channelUUID != null);

  final ServiceSettings serviceSettings;
  final String channelUUID;
}
