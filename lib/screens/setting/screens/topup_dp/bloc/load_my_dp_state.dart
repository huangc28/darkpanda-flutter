part of 'load_my_dp_bloc.dart';

class LoadMyDpState<E extends AppBaseException> extends Equatable {
  const LoadMyDpState._({
    this.status,
    this.myDp,
    this.error,
  });

  final AsyncLoadingStatus status;
  final MyDp myDp;
  final E error;

  LoadMyDpState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          myDp: null,
        );

  LoadMyDpState.loading(LoadMyDpState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          myDp: state.myDp,
        );

  const LoadMyDpState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadMyDpState.loaded({
    MyDp myDp,
  }) : this._(
          status: AsyncLoadingStatus.done,
          myDp: myDp,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
