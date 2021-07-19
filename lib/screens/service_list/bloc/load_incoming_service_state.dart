part of 'load_incoming_service_bloc.dart';

class LoadIncomingServiceState<E extends AppBaseException> extends Equatable {
  final Map<String, Message> chatroomLastMessage;
  final Map<String, StreamSubscription> privateChatStreamMap;
  final AsyncLoadingStatus status;
  final List<IncomingService> services;
  final E error;
  final int currentPage;

  const LoadIncomingServiceState._({
    this.status,
    this.services,
    this.error,
    this.chatroomLastMessage,
    this.privateChatStreamMap,
    this.currentPage,
  });

  LoadIncomingServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          services: [],
          chatroomLastMessage: {},
          privateChatStreamMap: {},
          currentPage: 0,
        );

  LoadIncomingServiceState.loading(LoadIncomingServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          services: state.services,
          chatroomLastMessage: state.chatroomLastMessage,
          privateChatStreamMap: state.privateChatStreamMap,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.loadFailed(
    LoadIncomingServiceState state, {
    E err,
  }) : this._(
          status: AsyncLoadingStatus.error,
          chatroomLastMessage: {},
          privateChatStreamMap: state.privateChatStreamMap,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.updateChatrooms(
    LoadIncomingServiceState state, {
    List<IncomingService> services,
    Map<String, StreamSubscription> privateChatStreamMap,
    int currentPage,
  }) : this._(
          privateChatStreamMap:
              privateChatStreamMap ?? state.privateChatStreamMap,
          services: services ?? state.services,
          status: AsyncLoadingStatus.done,
          chatroomLastMessage: state.chatroomLastMessage,
          currentPage: currentPage ?? state.currentPage,
        );

  LoadIncomingServiceState.putChatroomLatestMessage(
    LoadIncomingServiceState state, {
    Map<String, Message> chatroomLastMessage,
  }) : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          services: state.services,
          status: state.status,
          chatroomLastMessage: chatroomLastMessage ?? state.chatroomLastMessage,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.clearState(LoadIncomingServiceState state)
      : this._(
          services: state.services,
          status: AsyncLoadingStatus.initial,
          chatroomLastMessage: {},
          privateChatStreamMap: state.privateChatStreamMap,
          currentPage: 0,
        );

  @override
  List<Object> get props => [
        status,
        services,
        privateChatStreamMap,
        error,
        chatroomLastMessage,
        currentPage,
      ];
}
