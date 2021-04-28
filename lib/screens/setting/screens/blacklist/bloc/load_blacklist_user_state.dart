part of 'load_blacklist_user_bloc.dart';

class LoadBlacklistUserState<E extends AppBaseException> extends Equatable {
  const LoadBlacklistUserState._({
    this.status,
    this.blacklistUserList,
    this.error,
  });

  final AsyncLoadingStatus status;
  final List<BlacklistUser> blacklistUserList;
  final E error;

  LoadBlacklistUserState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          blacklistUserList: null,
        );

  LoadBlacklistUserState.loading(LoadBlacklistUserState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          blacklistUserList: state.blacklistUserList,
        );

  const LoadBlacklistUserState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadBlacklistUserState.loaded({
    List<BlacklistUser> blacklistUserList,
  }) : this._(
          status: AsyncLoadingStatus.done,
          blacklistUserList: blacklistUserList,
        );

  @override
  List<Object> get props => [
        status,
        blacklistUserList,
        error,
      ];
}
