part of 'inquiry_chatrooms_bloc.dart';

abstract class InquiryChatroomsEvent extends Equatable {
  const InquiryChatroomsEvent();

  @override
  List<Object> get props => [];
}

class FetchChatrooms extends InquiryChatroomsEvent {}

class AddChatrooms extends InquiryChatroomsEvent {
  final List<Chatroom> chatrooms;

  const AddChatrooms(this.chatrooms) : assert(chatrooms != null);
}

class LeaveChatroom extends InquiryChatroomsEvent {
  final String channelUUID;

  const LeaveChatroom({
    this.channelUUID,
  });
}

class PutLatestMessage extends InquiryChatroomsEvent {
  final String channelUUID;
  final Message message;

  const PutLatestMessage({
    this.channelUUID,
    this.message,
  });
}

class ClearInquiryChatList extends InquiryChatroomsEvent {
  const ClearInquiryChatList();
}
