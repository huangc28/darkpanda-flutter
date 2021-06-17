part of 'load_service_detail_bloc.dart';

class LoadServiceDetailState<E extends AppBaseException> extends Equatable {
  final Map<String, Message> chatroomLastMessage;
  final Map<String, StreamSubscription> privateChatStreamMap;
  final AsyncLoadingStatus status;
  final List<HistoricalService> services;
  final E error;

  const LoadServiceDetailState._({
    this.status,
    this.services,
    this.error,
    this.chatroomLastMessage,
    this.privateChatStreamMap,
  });

  LoadServiceDetailState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          services: [],
          chatroomLastMessage: {},
          privateChatStreamMap: {},
        );

  LoadServiceDetailState.loading(LoadServiceDetailState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          services: [],
          chatroomLastMessage: state.chatroomLastMessage,
          privateChatStreamMap: state.privateChatStreamMap,
        );

  LoadServiceDetailState.loadFailed(LoadServiceDetailState state, E err)
      : this._(
          status: AsyncLoadingStatus.error,
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
