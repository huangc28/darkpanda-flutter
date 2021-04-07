part of 'inquiry_chatrooms_bloc.dart';

class InquiryChatroomsState<E extends AppBaseException> extends Equatable {
  final List<Chatroom> chatrooms;
  final E error;

  /// Key value map of `channel UUID` and corresponding message [StreamSubscription].
  final Map<String, StreamSubscription> privateChatStreamMap;

  final AsyncLoadingStatus status;

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
          status: AsyncLoadingStatus.initial,
        );

  InquiryChatroomsState.loading(InquiryChatroomsState state)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: AsyncLoadingStatus.loading,
        );

  InquiryChatroomsState.loadFailed(InquiryChatroomsState state, E err)
      : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
          status: AsyncLoadingStatus.error,
        );

  InquiryChatroomsState.updateChatrooms(InquiryChatroomsState state)
      : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          chatrooms: state.chatrooms,
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        status,
        chatrooms,
        privateChatStreamMap,
        error,
      ];
}
