part of 'current_service_chatroom_bloc.dart';

class CurrentServiceChatroomState<E extends AppBaseException>
    extends Equatable {
  const CurrentServiceChatroomState._({
    this.status,
    this.historicalMessages,
    this.currentMessages,
    this.userProfile,
    this.page,
    this.error,
    this.serviceStreamMap,
    this.service,
  });

  final AsyncLoadingStatus status;
  final List<Message> historicalMessages;
  final List<Message> currentMessages;
  final UserProfile userProfile;
  final int page;
  final E error;
  final Map<String, StreamSubscription> serviceStreamMap;
  final IncomingService service;

  CurrentServiceChatroomState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
          page: 1,
          historicalMessages: [],
          currentMessages: [],
          userProfile: UserProfile(),
          serviceStreamMap: {},
          service: null,
        );

  CurrentServiceChatroomState.loading(CurrentServiceChatroomState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          page: state.page,
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          userProfile: state.userProfile,
          serviceStreamMap: state.serviceStreamMap,
          service: state.service,
        );

  CurrentServiceChatroomState.loadFailed(
      CurrentServiceChatroomState state, E error)
      : this._(
          status: AsyncLoadingStatus.error,
          page: state.page,
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          error: error,
          userProfile: state.userProfile,
          serviceStreamMap: state.serviceStreamMap,
          service: state.service,
        );

  CurrentServiceChatroomState.loaded(
    CurrentServiceChatroomState state, {
    UserProfile inquirerProfile,
    List<Message> historicalMessages,
    int page,
    Map<String, StreamSubscription<DocumentSnapshot>> serviceStreamMap,
    IncomingService service,
  }) : this._(
          status: AsyncLoadingStatus.done,
          historicalMessages: historicalMessages ?? state.historicalMessages,
          currentMessages: state.currentMessages,
          page: page ?? state.page,
          userProfile: inquirerProfile ?? state.userProfile,
          serviceStreamMap: serviceStreamMap ?? state.serviceStreamMap,
          service: service ?? state.service,
        );

  CurrentServiceChatroomState.updateCurrentMessage(
    CurrentServiceChatroomState state,
    List<Message> currentMessages,
  ) : this._(
          page: state.page,
          status: state.status,
          historicalMessages: state.historicalMessages,
          userProfile: state.userProfile,
          currentMessages: currentMessages,
          serviceStreamMap: state.serviceStreamMap,
          service: state.service,
        );

  CurrentServiceChatroomState.putService(CurrentServiceChatroomState state,
      {IncomingService service})
      : this._(
          status: state.status,
          historicalMessages: state.historicalMessages,
          currentMessages: state.currentMessages,
          userProfile: state.userProfile,
          page: state.page,
          serviceStreamMap: state.serviceStreamMap,
          service: service ?? state.service,
        );

  CurrentServiceChatroomState.putServiceStreamMap(
    CurrentServiceChatroomState state, {
    Map<String, StreamSubscription> serviceStreamMap,
  }) : this._(
          page: state.page,
          status: state.status,
          historicalMessages: state.historicalMessages,
          userProfile: state.userProfile,
          currentMessages: state.currentMessages,
          serviceStreamMap: serviceStreamMap ?? state.serviceStreamMap,
          service: state.service,
        );

  CurrentServiceChatroomState.clearCurrentChatroom(
      CurrentServiceChatroomState state)
      : this._(
          status: AsyncLoadingStatus.initial,
          page: 1,
          historicalMessages: [],
          currentMessages: [],
          userProfile: UserProfile(),
          serviceStreamMap: {},
          service: state.service,
        );

  List<Message> get messages {
    return List.from(historicalMessages)..addAll(currentMessages);
  }

  @override
  List<Object> get props => [
        status,
        error,
        historicalMessages.length,
        currentMessages.length,
        messages,
        serviceStreamMap,
        service,
      ];
}
