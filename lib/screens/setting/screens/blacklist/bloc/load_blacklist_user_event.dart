part of 'load_blacklist_user_bloc.dart';

abstract class LoadBlacklistUserEvent extends Equatable {
  const LoadBlacklistUserEvent();

  @override
  List<Object> get props => [];
}

class LoadBlacklistUser extends LoadBlacklistUserEvent {
  const LoadBlacklistUser({
    this.uuid,
  });

  final String uuid;
}
