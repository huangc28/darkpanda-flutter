part of 'load_incoming_service_bloc.dart';

abstract class LoadIncomingServiceEvent extends Equatable {
  const LoadIncomingServiceEvent();

  @override
  List<Object> get props => [];
}

class AddChatrooms extends LoadIncomingServiceEvent {
  final List<IncomingService> chatrooms;

  const AddChatrooms(this.chatrooms) : assert(chatrooms != null);
}

class LoadIncomingService extends LoadIncomingServiceEvent {
  const LoadIncomingService({
    this.perPage = 7,
    this.nextPage = 1,
  }) : assert(nextPage > 0);

  final int perPage;
  final int nextPage;
}

class LoadMoreIncomingService extends LoadIncomingServiceEvent {
  final int perPage;

  const LoadMoreIncomingService({
    this.perPage = 7,
  });
}

class PutLatestMessage extends LoadIncomingServiceEvent {
  final String channelUUID;
  final Message message;

  const PutLatestMessage({
    this.channelUUID,
    this.message,
  });
}

class ClearIncomingServiceState extends LoadIncomingServiceEvent {
  const ClearIncomingServiceState();
}
