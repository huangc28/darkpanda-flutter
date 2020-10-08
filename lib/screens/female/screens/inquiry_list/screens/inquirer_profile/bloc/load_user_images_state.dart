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

  const LoadUserImagesState._({
    this.status,
    this.error,
    this.userImages,
  });

  const LoadUserImagesState.initial()
      : this._(
          status: LoadUserImagesStatus.initial,
        );

  const LoadUserImagesState.loading()
      : this._(
          status: LoadUserImagesStatus.loading,
        );

  const LoadUserImagesState.loadFailed(E error)
      : this._(
          status: LoadUserImagesStatus.loadFailed,
          error: error,
        );

  const LoadUserImagesState.loaded(List<UserImage> images)
      : this._(
          status: LoadUserImagesStatus.loaded,
          userImages: images,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
