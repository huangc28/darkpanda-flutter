part of 'load_direct_inquiry_chatrooms_bloc.dart';

class LoadDirectInquiryChatroomsState<E extends AppBaseException>
    extends Equatable {
  final List<Chatroom> chatrooms;
  final E error;

  /// Key value map of `channel UUID` and corresponding message [StreamSubscription].
  final Map<String, StreamSubscription> privateChatStreamMap;
  final AsyncLoadingStatus status;

  /// This map keeps track on the latest message for each chatroom. Chatroom list
  /// would display the latest message for each chatroom.
  final Map<String, Message> chatroomLastMessage;

  final int currentPage;

  const LoadDirectInquiryChatroomsState._({
    this.chatrooms,
    this.privateChatStreamMap,
    this.error,
    this.status,
    this.chatroomLastMessage,
    this.currentPage,
  });

  LoadDirectInquiryChatroomsState.init()
      : this._(
          chatrooms: [],
          privateChatStreamMap: {},
          status: AsyncLoadingStatus.initial,
          chatroomLastMessage: {},
          currentPage: 0,
        );

  LoadDirectInquiryChatroomsState.loading(LoadDirectInquiryChatroomsState state)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: AsyncLoadingStatus.loading,
          chatroomLastMessage: state.chatroomLastMessage,
          currentPage: state.currentPage,
        );

  LoadDirectInquiryChatroomsState.loadFailed(
      LoadDirectInquiryChatroomsState state, E err)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: AsyncLoadingStatus.error,
          chatroomLastMessage: state.chatroomLastMessage,
          currentPage: state.currentPage,
        );

  LoadDirectInquiryChatroomsState.updateChatrooms(
    LoadDirectInquiryChatroomsState state, {
    List<Chatroom> chatrooms,
    Map<String, StreamSubscription> privateChatStreamMap,
    int currentPage,
  }) : this._(
          privateChatStreamMap:
              privateChatStreamMap ?? state.privateChatStreamMap,
          chatrooms: chatrooms ?? state.chatrooms,
          status: AsyncLoadingStatus.done,
          chatroomLastMessage: state.chatroomLastMessage,
          currentPage: currentPage ?? state.currentPage,
        );

  LoadDirectInquiryChatroomsState.putChatroomLatestMessage(
    LoadDirectInquiryChatroomsState state, {
    Map<String, Message> chatroomLastMessage,
  }) : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          chatrooms: state.chatrooms,
          // status: state.status,
          chatroomLastMessage: chatroomLastMessage ?? state.chatroomLastMessage,
          currentPage: state.currentPage,
        );

  LoadDirectInquiryChatroomsState.clearInqiuryChatList(
      LoadDirectInquiryChatroomsState state)
      : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          chatrooms: [],
          status: AsyncLoadingStatus.initial,
          // status: state.status,
          chatroomLastMessage: {},
          currentPage: 0,
        );

  @override
  List<Object> get props => [
        status,
        chatrooms,
        privateChatStreamMap,
        error,
        chatroomLastMessage,
        currentPage,
      ];
}
