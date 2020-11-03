part of 'fetch_chats_bloc.dart';

enum FetchChatsStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class FetchChatsState<E extends AppBaseException> extends Equatable {
  const FetchChatsState._({
    this.status,
    this.error,
  });

  final FetchChatsStatus status;
  final E error;

  FetchChatsState.init()
      : this._(
          status: FetchChatsStatus.initial,
        );

  FetchChatsState.loading()
      : this._(
          status: FetchChatsStatus.loading,
        );

  FetchChatsState.loadFailed(E err)
      : this._(
          status: FetchChatsStatus.loadFailed,
          error: err,
        );

  FetchChatsState.loaded()
      : this._(
          status: FetchChatsStatus.loaded,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
