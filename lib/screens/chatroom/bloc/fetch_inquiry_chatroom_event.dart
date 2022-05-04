part of 'fetch_inquiry_chatroom_bloc.dart';

abstract class FetchInquiryChatroomEvent extends Equatable {
  const FetchInquiryChatroomEvent({
    this.inquiryUUID,
  });

  final String inquiryUUID;

  @override
  List<Object> get props => [inquiryUUID];
}

class FetchInquiryChatroom extends FetchInquiryChatroomEvent {
  const FetchInquiryChatroom({String inquiryUUID})
      : super(inquiryUUID: inquiryUUID);
}
