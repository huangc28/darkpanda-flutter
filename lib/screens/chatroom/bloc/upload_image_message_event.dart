part of 'upload_image_message_bloc.dart';

abstract class UploadImageMessageEvent extends Equatable {
  const UploadImageMessageEvent();

  @override
  List<Object> get props => [];
}

class UploadImageMessage extends UploadImageMessageEvent {
  const UploadImageMessage({
    this.imageFile,
  });

  final File imageFile;

  @override
  List<Object> get props => [imageFile];
}
