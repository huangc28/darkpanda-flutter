part of 'update_is_read_bloc.dart';

abstract class UpdateIsReadEvent extends Equatable {
  const UpdateIsReadEvent();

  @override
  List<Object> get props => [];
}

class UpdateIsRead extends UpdateIsReadEvent {
  const UpdateIsRead({
    this.channelUUID,
  });

  final String channelUUID;

  @override
  List<Object> get props => [];
}
