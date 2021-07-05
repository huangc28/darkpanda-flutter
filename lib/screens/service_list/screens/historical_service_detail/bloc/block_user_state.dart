part of 'block_user_bloc.dart';

class BlockUserState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;

  const BlockUserState._({
    this.status,
    this.error,
  });

  BlockUserState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  BlockUserState.loading(BlockUserState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  BlockUserState.loadSuccess(BlockUserState state)
      : this._(
          status: AsyncLoadingStatus.done,
        );

  BlockUserState.loadFailed(BlockUserState state, E err)
      : this._(
          status: AsyncLoadingStatus.error,
        );

  @override
  List<Object> get props => [
        status,
        error,
      ];
}
