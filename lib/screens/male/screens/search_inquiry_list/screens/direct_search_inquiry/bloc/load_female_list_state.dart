part of 'load_female_list_bloc.dart';

class LoadFemaleListState<E extends AppBaseException> extends Equatable {
  const LoadFemaleListState._({
    this.status,
    this.femaleUsers,
    this.error,
    this.currentPage,
  });

  final AsyncLoadingStatus status;
  final List<FemaleUser> femaleUsers;
  final E error;
  final int currentPage;

  LoadFemaleListState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          currentPage: 0,
        );

  LoadFemaleListState.loading(LoadFemaleListState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          currentPage: state.currentPage,
        );

  LoadFemaleListState.loadFailed(LoadFemaleListState state, E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
          currentPage: state.currentPage,
        );

  LoadFemaleListState.loaded(
    LoadFemaleListState state, {
    List<FemaleUser> femaleUsers,
    int currentPage,
  }) : this._(
          status: AsyncLoadingStatus.done,
          femaleUsers: femaleUsers ?? state.femaleUsers,
          currentPage: currentPage ?? state.currentPage,
        );

  LoadFemaleListState.clearState(LoadFemaleListState state)
      : this._(
          femaleUsers: [],
          status: AsyncLoadingStatus.initial,
          currentPage: 0,
        );

  @override
  List<Object> get props => [
        status,
        error,
        femaleUsers,
        currentPage,
      ];
}
