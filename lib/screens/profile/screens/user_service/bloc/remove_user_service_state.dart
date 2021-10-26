part of 'remove_user_service_bloc.dart';

class RemoveUserServiceState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const RemoveUserServiceState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const RemoveUserServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const RemoveUserServiceState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const RemoveUserServiceState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const RemoveUserServiceState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
