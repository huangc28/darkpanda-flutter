part of 'load_incoming_service_bloc.dart';

class LoadIncomingServiceState<E extends AppBaseException> extends Equatable {
  final Map<String, Message> chatroomLastMessage;
  final Map<String, StreamSubscription> privateChatStreamMap;
  final AsyncLoadingStatus status;
  final List<IncomingService> services;
  final E error;

  const LoadIncomingServiceState._({
    this.status,
    this.services,
    this.error,
    this.chatroomLastMessage,
    this.privateChatStreamMap,
  });

  LoadIncomingServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          services: [],
          chatroomLastMessage: {},
          privateChatStreamMap: {},
        );

  LoadIncomingServiceState.loading(LoadIncomingServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          services: [],
          chatroomLastMessage: state.chatroomLastMessage,
          privateChatStreamMap: state.privateChatStreamMap,
        );

  LoadIncomingServiceState.loadFailed(LoadIncomingServiceState state, E err)
      : this._(
          status: AsyncLoadingStatus.error,
          chatroomLastMessage: {},
          privateChatStreamMap: state.privateChatStreamMap,
        );

  // LoadIncomingServiceState.loaded({
  //   LoadIncomingServiceState state,
  //   List<IncomingService> services,
  // }) : this._(
  //         status: AsyncLoadingStatus.done,
  //         services: services,
  //         // chatroomLastMessage: state.chatroomLastMessage,
  //       );

  LoadIncomingServiceState.updateChatrooms(
    LoadIncomingServiceState state, {
    List<IncomingService> services,
    Map<String, StreamSubscription> privateChatStreamMap,
  }) : this._(
          privateChatStreamMap:
              privateChatStreamMap ?? state.privateChatStreamMap,
          services: services ?? state.services,
          status: AsyncLoadingStatus.done,
          chatroomLastMessage: state.chatroomLastMessage,
        );

  LoadIncomingServiceState.putChatroomLatestMessage(
    LoadIncomingServiceState state, {
    Map<String, Message> chatroomLastMessage,
  }) : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          services: state.services,
          status: state.status,
          chatroomLastMessage: chatroomLastMessage ?? state.chatroomLastMessage,
        );

  LoadIncomingServiceState.clearState(LoadIncomingServiceState state)
      : this._(
          services: [],
          status: AsyncLoadingStatus.initial,
          chatroomLastMessage: {},
          privateChatStreamMap: state.privateChatStreamMap,
        );

  @override
  List<Object> get props => [
        status,
        services,
        privateChatStreamMap,
        error,
        chatroomLastMessage,
      ];
}
