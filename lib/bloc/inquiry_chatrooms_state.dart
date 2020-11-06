part of 'inquiry_chatrooms_bloc.dart';

enum FetchInquiryChatroomStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class InquiryChatroomsState<E extends AppBaseException> extends Equatable {
  final List<Chatroom> chatrooms;
  final E error;

  // Map of channel UUID and stream.
  final Map<String, StreamSubscription> privateChatStreamMap;

  final FetchInquiryChatroomStatus status;

  const InquiryChatroomsState._({
    this.chatrooms,
    this.privateChatStreamMap,
    this.error,
    this.status,
  });

  InquiryChatroomsState.init()
      : this._(
          chatrooms: [],
          privateChatStreamMap: {},
          status: FetchInquiryChatroomStatus.initial,
        );

  InquiryChatroomsState.loading(InquiryChatroomsState state)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: FetchInquiryChatroomStatus.loading,
        );

  InquiryChatroomsState.loadFailed(InquiryChatroomsState state, E err)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: FetchInquiryChatroomStatus.loadFailed,
        );

  InquiryChatroomsState.updateChatrooms(InquiryChatroomsState state)
      : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          chatrooms: state.chatrooms,
          status: FetchInquiryChatroomStatus.loaded,
        );

  @override
  List<Object> get props => [
        status,
        chatrooms,
        privateChatStreamMap,
        error,
      ];
}
