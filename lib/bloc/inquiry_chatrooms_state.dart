part of 'inquiry_chatrooms_bloc.dart';

class InquiryChatroomsState<E extends AppBaseException> extends Equatable {
  final List<Chatroom> chatrooms;
  final E error;

  /// Key value map of `channel UUID` and corresponding message [StreamSubscription].
  final Map<String, StreamSubscription> privateChatStreamMap;
  final AsyncLoadingStatus status;

  /// This map keeps track on the latest message for each chatroom. Chatroom list
  /// would display the latest message for each chatroom.
  final Map<String, Message> chatroomLastMessage;

  const InquiryChatroomsState._({
    this.chatrooms,
    this.privateChatStreamMap,
    this.error,
    this.status,
    this.chatroomLastMessage,
  });

  InquiryChatroomsState.init()
      : this._(
          chatrooms: [],
          privateChatStreamMap: {},
          status: AsyncLoadingStatus.initial,
          chatroomLastMessage: {},
        );

  InquiryChatroomsState.loading(InquiryChatroomsState state)
      : this._(
          chatrooms: [],
          privateChatStreamMap: state.privateChatStreamMap,
          status: AsyncLoadingStatus.loading,
          chatroomLastMessage: state.chatroomLastMessage,
        );

  InquiryChatroomsState.loadFailed(InquiryChatroomsState state, E err)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: AsyncLoadingStatus.error,
          chatroomLastMessage: state.chatroomLastMessage,
        );

  InquiryChatroomsState.updateChatrooms(
    InquiryChatroomsState state, {
    List<Chatroom> chatrooms,
    Map<String, StreamSubscription> privateChatStreamMap,
  }) : this._(
          privateChatStreamMap:
              privateChatStreamMap ?? state.privateChatStreamMap,
          chatrooms: chatrooms ?? state.chatrooms,
          status: AsyncLoadingStatus.done,
          chatroomLastMessage: state.chatroomLastMessage,
        );

  InquiryChatroomsState.putChatroomLatestMessage(
    InquiryChatroomsState state, {
    Map<String, Message> chatroomLastMessage,
  }) : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          chatrooms: state.chatrooms,
          status: state.status,
          chatroomLastMessage: chatroomLastMessage ?? state.chatroomLastMessage,
        );

  @override
  List<Object> get props => [
        status,
        chatrooms,
        privateChatStreamMap,
        error,
        chatroomLastMessage,
      ];
}
