part of 'upload_image_message_bloc.dart';

enum SendMessageStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class UploadImageMessageState<E extends AppBaseException> extends Equatable {
  const UploadImageMessageState._({
    this.status,
    this.error,
    this.chatImages,
  });

  final AsyncLoadingStatus status;
  final E error;
  final List<ChatImage> chatImages;

  UploadImageMessageState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
          chatImages: [],
        );

  UploadImageMessageState.loading(UploadImageMessageState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          chatImages: [],
        );

  UploadImageMessageState.loadFailed(E error)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: error,
        );

  UploadImageMessageState.loaded(
    UploadImageMessageState state, {
    List<ChatImage> chatImages,
  }) : this._(
          status: AsyncLoadingStatus.done,
          chatImages: chatImages ?? state.chatImages,
        );

  @override
  List<Object> get props => [status];
}
