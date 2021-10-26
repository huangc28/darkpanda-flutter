part of 'add_user_service_bloc.dart';

class AddUserServiceState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const AddUserServiceState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const AddUserServiceState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const AddUserServiceState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const AddUserServiceState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const AddUserServiceState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
