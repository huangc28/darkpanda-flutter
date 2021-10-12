part of 'load_direct_inquiry_chatrooms_bloc.dart';

abstract class LoadDirectInquiryChatroomsEvent extends Equatable {
  const LoadDirectInquiryChatroomsEvent();

  @override
  List<Object> get props => [];
}

class FetchDirectInquiryChatrooms extends LoadDirectInquiryChatroomsEvent {
  final int perPage;
  final int nextPage;

  FetchDirectInquiryChatrooms({
    this.perPage = 7,
    this.nextPage = 1,
  }) : assert(nextPage > 0);
}

class LoadMoreChatrooms extends LoadDirectInquiryChatroomsEvent {
  final int perPage;

  const LoadMoreChatrooms({
    this.perPage = 7,
  });
}

class AddChatroom extends LoadDirectInquiryChatroomsEvent {
  final Chatroom chatroom;

  const AddChatroom({this.chatroom}) : assert(chatroom != null);
}

class LeaveMaleChatroom extends LoadDirectInquiryChatroomsEvent {
  final String channelUUID;

  const LeaveMaleChatroom({
    this.channelUUID,
  });
}

class AddChatrooms extends LoadDirectInquiryChatroomsEvent {
  final List<Chatroom> chatrooms;

  const AddChatrooms(this.chatrooms) : assert(chatrooms != null);
}

class LeaveChatroom extends LoadDirectInquiryChatroomsEvent {
  final String channelUUID;

  const LeaveChatroom({
    this.channelUUID,
  });
}

class PutLatestMessage extends LoadDirectInquiryChatroomsEvent {
  final String channelUUID;
  final Message message;

  const PutLatestMessage({
    this.channelUUID,
    this.message,
  });
}

class ClearInquiryChatList extends LoadDirectInquiryChatroomsEvent {
  const ClearInquiryChatList();
}

class ClearInquiryList extends LoadDirectInquiryChatroomsEvent {
  const ClearInquiryList();
}
