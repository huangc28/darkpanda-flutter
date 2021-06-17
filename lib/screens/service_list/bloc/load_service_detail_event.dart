part of 'load_service_detail_bloc.dart';

abstract class LoadServiceDetailEvent extends Equatable {
  const LoadServiceDetailEvent();

  @override
  List<Object> get props => [];
}

class AddChatrooms extends LoadServiceDetailEvent {
  final List<HistoricalService> chatrooms;

  const AddChatrooms(this.chatrooms) : assert(chatrooms != null);
}

class LoadServiceDetail extends LoadServiceDetailEvent {
  const LoadServiceDetail();
}

class PutLatestMessage extends LoadServiceDetailEvent {
  final String channelUUID;
  final Message message;

  const PutLatestMessage({
    this.channelUUID,
    this.message,
  });
}

class ClearIncomingServiceState extends LoadServiceDetailEvent {
  const ClearIncomingServiceState();
}
