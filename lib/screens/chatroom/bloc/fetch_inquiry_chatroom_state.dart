part of 'fetch_inquiry_chatroom_bloc.dart';

abstract class FetchInquiryChatroomState<E extends AppBaseException>
    extends Equatable {
  const FetchInquiryChatroomState({
    this.status,
    this.error,
    this.chatroom,
  });

  final AsyncLoadingStatus status;
  final E error;
  final Chatroom chatroom;

  @override
  List<Object> get props => [
        status,
        error,
        chatroom,
      ];
}

class FetchInquiryChatroomInitial extends FetchInquiryChatroomState {
  const FetchInquiryChatroomInitial()
      : super(
          status: AsyncLoadingStatus.initial,
          error: null,
          chatroom: null,
        );
}

class FetchingInquiryChatroom extends FetchInquiryChatroomState {
  const FetchingInquiryChatroom()
      : super(
          status: AsyncLoadingStatus.initial,
          error: null,
          chatroom: null,
        );
}

class FetchInquiryChatroomSuccess extends FetchInquiryChatroomState {
  const FetchInquiryChatroomSuccess(Chatroom chatroom)
      : super(
          status: AsyncLoadingStatus.done,
          chatroom: chatroom,
        );
}

class FetchInquiryChatroomFailed<E extends AppBaseException>
    extends FetchInquiryChatroomState {
  const FetchInquiryChatroomFailed({E error})
      : super(
          status: AsyncLoadingStatus.error,
          error: error,
        );
}
