part of 'load_dp_package_bloc.dart';

class LoadDpPackageState<E extends AppBaseException> extends Equatable {
  const LoadDpPackageState._({
    this.status,
    this.dpPackageList,
    this.error,
  });

  final AsyncLoadingStatus status;
  final DpPackageList dpPackageList;
  final E error;

  LoadDpPackageState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          dpPackageList: null,
        );

  LoadDpPackageState.loading(LoadDpPackageState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          dpPackageList: state.dpPackageList,
        );

  const LoadDpPackageState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadDpPackageState.loaded({
    DpPackageList dpPackageList,
  }) : this._(
          status: AsyncLoadingStatus.done,
          dpPackageList: dpPackageList,
        );

  const LoadDpPackageState.clearState()
      : this._(
          dpPackageList: null,
          status: AsyncLoadingStatus.initial,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
