part of 'fetch_chats_bloc.dart';

enum FetchChatsStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class FetchChatsState extends Equatable {
  const FetchChatsState._({
    this.status,
  });

  final FetchChatsStatus status;

  FetchChatsState.init()
      : this._(
          status: FetchChatsStatus.initial,
        );

  FetchChatsState.loading()
      : this._(
          status: FetchChatsStatus.loading,
        );

  FetchChatsState.loadFailed()
      : this._(
          status: FetchChatsStatus.loadFailed,
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
