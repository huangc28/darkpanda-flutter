part of 'load_incoming_service_bloc.dart';

class LoadIncomingServiceState<E extends AppBaseException> extends Equatable {
  final Map<String, Message> chatroomLastMessage;
  final Map<String, StreamSubscription> privateChatStreamMap;
  final Map<String, StreamSubscription> serviceStreamMap;
  final AsyncLoadingStatus status;
  final List<IncomingService> services;
  final Map<String, ServiceStatus> service;
  final E error;
  final int currentPage;

  const LoadIncomingServiceState._({
    this.status,
    this.services,
    this.service,
    this.error,
    this.chatroomLastMessage,
    this.privateChatStreamMap,
    this.serviceStreamMap,
    this.currentPage,
  });

  LoadIncomingServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          services: [],
          service: {},
          chatroomLastMessage: {},
          privateChatStreamMap: {},
          serviceStreamMap: {},
          currentPage: 0,
        );

  LoadIncomingServiceState.loading(LoadIncomingServiceState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          services: state.services,
          service: state.service,
          chatroomLastMessage: state.chatroomLastMessage,
          privateChatStreamMap: state.privateChatStreamMap,
          serviceStreamMap: state.serviceStreamMap,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.loadFailed(
    LoadIncomingServiceState state, {
    E err,
  }) : this._(
          status: AsyncLoadingStatus.error,
          service: {},
          chatroomLastMessage: {},
          privateChatStreamMap: state.privateChatStreamMap,
          serviceStreamMap: state.serviceStreamMap,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.updateChatrooms(
    LoadIncomingServiceState state, {
    List<IncomingService> services,
    Map<String, StreamSubscription> privateChatStreamMap,
    Map<String, StreamSubscription> serviceStreamMap,
    Map<String, Message> chatroomLastMessage,
    Map<String, ServiceStatus> service,
    int currentPage,
  }) : this._(
          privateChatStreamMap:
              privateChatStreamMap ?? state.privateChatStreamMap,
          serviceStreamMap: serviceStreamMap ?? state.serviceStreamMap,
          chatroomLastMessage: chatroomLastMessage ?? state.chatroomLastMessage,
          services: services ?? state.services,
          service: service ?? state.service,
          status: AsyncLoadingStatus.done,
          currentPage: currentPage ?? state.currentPage,
        );

  LoadIncomingServiceState.putChatroomLatestMessage(
    LoadIncomingServiceState state, {
    Map<String, Message> chatroomLastMessage,
  }) : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          serviceStreamMap: state.serviceStreamMap,
          services: state.services,
          service: state.service,
          status: state.status,
          chatroomLastMessage: chatroomLastMessage ?? state.chatroomLastMessage,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.putChatroomService(
    LoadIncomingServiceState state, {
    Map<String, ServiceStatus> service,
  }) : this._(
          privateChatStreamMap: state.privateChatStreamMap,
          serviceStreamMap: state.serviceStreamMap,
          services: state.services,
          service: service ?? state.service,
          status: state.status,
          chatroomLastMessage: state.chatroomLastMessage,
          currentPage: state.currentPage,
        );

  LoadIncomingServiceState.clearState(LoadIncomingServiceState state)
      : this._(
          services: state.services,
          status: AsyncLoadingStatus.initial,
          service: state.service,
          chatroomLastMessage: {},
          privateChatStreamMap: state.privateChatStreamMap,
          serviceStreamMap: {},
          currentPage: 0,
        );

  @override
  List<Object> get props => [
        status,
        services,
        service,
        privateChatStreamMap,
        serviceStreamMap,
        error,
        chatroomLastMessage,
        currentPage,
      ];
}
