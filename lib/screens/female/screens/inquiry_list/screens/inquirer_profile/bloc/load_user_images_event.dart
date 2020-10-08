part of 'load_user_images_bloc.dart';

abstract class LoadUserImagesEvent extends Equatable {
  const LoadUserImagesEvent();

  @override
  List<Object> get props => [];
}

class LoadUserImages extends LoadUserImagesEvent {
  final String uuid;

  const LoadUserImages({this.uuid});
}
