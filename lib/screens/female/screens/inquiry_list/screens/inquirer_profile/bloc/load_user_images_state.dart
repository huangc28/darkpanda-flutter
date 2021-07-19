part of 'load_user_images_bloc.dart';

class LoadUserImagesState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;
  final List<UserImage> userImages;
  final int currentPage;

  const LoadUserImagesState._({
    this.status,
    this.error,
    this.userImages,
    this.currentPage,
  });

  LoadUserImagesState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          currentPage: 0,
          userImages: <UserImage>[],
        );

  LoadUserImagesState.loading(LoadUserImagesState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          userImages: state.userImages,
          currentPage: state.currentPage,
        );

  LoadUserImagesState.loadFailed(LoadUserImagesState state, {E error})
      : this._(
          status: AsyncLoadingStatus.error,
          error: error ?? state.error,
          userImages: state.userImages,
          currentPage: state.currentPage,
        );

  const LoadUserImagesState.loaded(List<UserImage> images, int currentPage)
      : this._(
          status: AsyncLoadingStatus.done,
          userImages: images,
          currentPage: currentPage,
        );

  LoadUserImagesState.clearState(LoadUserImagesState state)
      : this._(
          status: AsyncLoadingStatus.initial,
          userImages: <UserImage>[],
          currentPage: 0,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
