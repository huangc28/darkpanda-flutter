part of 'remove_blacklist_bloc.dart';

abstract class RemoveBlacklistEvent extends Equatable {
  const RemoveBlacklistEvent();

  @override
  List<Object> get props => [];
}

class RemoveBlacklist extends RemoveBlacklistEvent {
  const RemoveBlacklist({
    this.uuid,
    this.blacklistId,
  });

  final String uuid;
  final int blacklistId;
}
