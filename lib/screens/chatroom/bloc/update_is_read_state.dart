part of 'update_is_read_bloc.dart';

class UpdateIsReadState<E extends AppBaseException> extends Equatable {
  const UpdateIsReadState._({
    this.status,
    this.error,
  });

  final AsyncLoadingStatus status;
  final E error;

  UpdateIsReadState.init() : this._(status: AsyncLoadingStatus.initial);

  UpdateIsReadState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  UpdateIsReadState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: error,
        );

  UpdateIsReadState.loaded()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [status];
}
