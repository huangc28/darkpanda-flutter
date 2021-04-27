part of 'remove_blacklist_bloc.dart';

class RemoveBlacklistState<E extends AppBaseException> extends Equatable {
  const RemoveBlacklistState._({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;
  final E error;

  RemoveBlacklistState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  RemoveBlacklistState.loading(RemoveBlacklistState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const RemoveBlacklistState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const RemoveBlacklistState.loaded()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
