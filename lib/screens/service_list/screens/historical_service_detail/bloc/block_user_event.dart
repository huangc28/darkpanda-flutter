part of 'block_user_bloc.dart';

abstract class BlockUserEvent extends Equatable {
  const BlockUserEvent();

  @override
  List<Object> get props => [];
}

class BlockUser extends BlockUserEvent {
  const BlockUser({
    this.uuid,
  });
  final String uuid;

  @override
  List<Object> get props => [uuid];
}
