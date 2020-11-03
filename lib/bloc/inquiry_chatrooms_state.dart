part of 'inquiry_chatrooms_bloc.dart';

class InquiryChatroomsState<E extends AppBaseException> extends Equatable {
  final List<Chatroom> chatrooms;
  final E error;

  // Map of channel UUID and stream.
  final Map<String, StreamSubscription> privateChatStreamMap;

  const InquiryChatroomsState._({
    this.chatrooms,
    this.privateChatStreamMap,
    this.error,
  });

  InquiryChatroomsState.init()
      : this._(
          chatrooms: [],
          privateChatStreamMap: {},
        );

  InquiryChatroomsState.updateChatrooms(
      InquiryChatroomsState state, List<Chatroom> chatrooms)
      : this._(
          chatrooms: chatrooms,
          privateChatStreamMap: state.privateChatStreamMap,
        );

  InquiryChatroomsState.updatePrivateChatStreamMap(
    InquiryChatroomsState state,
    Map<String, StreamSubscription> map,
  ) : this._(
          chatrooms: state.chatrooms,
          privateChatStreamMap: map,
        );

  InquiryChatroomsState.failed(InquiryChatroomsState state, E error)
      : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          error: error,
        );

  @override
  List<Object> get props => [
        privateChatStreamMap,
      ];
}
