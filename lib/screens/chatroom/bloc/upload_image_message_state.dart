part of 'upload_image_message_bloc.dart';

class UploadImageMessageState<E extends AppBaseException> extends Equatable {
  const UploadImageMessageState._({
    this.status,
    this.error,
    this.chatImages,
  });

  final AsyncLoadingStatus status;
  final E error;
  final ChatImage chatImages;

  UploadImageMessageState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
          chatImages: null,
        );

  UploadImageMessageState.loading(UploadImageMessageState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          chatImages: null,
        );

  UploadImageMessageState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  UploadImageMessageState.loaded(
    UploadImageMessageState state, {
    ChatImage chatImages,
  }) : this._(
          status: AsyncLoadingStatus.done,
          chatImages: chatImages ?? state.chatImages,
        );

  @override
  List<Object> get props => [status, chatImages, error];
}
