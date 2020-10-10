part of 'load_user_images_bloc.dart';

enum LoadUserImagesStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class LoadUserImagesState<E extends AppBaseException> extends Equatable {
  final LoadUserImagesStatus status;
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
          status: LoadUserImagesStatus.initial,
          currentPage: 0,
          userImages: <UserImage>[],
        );

  LoadUserImagesState.loading(LoadUserImagesState state)
      : this._(
          status: LoadUserImagesStatus.loading,
          userImages: state.userImages,
          currentPage: state.currentPage,
        );

  LoadUserImagesState.loadFailed(LoadUserImagesState state, {E error})
      : this._(
          status: LoadUserImagesStatus.loadFailed,
          error: error ?? state.error,
          userImages: state.userImages,
          currentPage: state.currentPage,
        );

  const LoadUserImagesState.loaded(List<UserImage> images, int currentPage)
      : this._(
          status: LoadUserImagesStatus.loaded,
          userImages: images,
          currentPage: currentPage,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
