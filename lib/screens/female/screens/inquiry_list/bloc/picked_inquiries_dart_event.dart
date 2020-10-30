part of 'picked_inquiries_dart_bloc.dart';

abstract class PickedInquiriesDartEvent extends Equatable {
  const PickedInquiriesDartEvent();

  @override
  List<Object> get props => [];
}

class AddPickedInqiury extends PickedInquiriesDartEvent {
  final PickedInquiry pickedInquiry;

  const AddPickedInqiury({
    this.pickedInquiry,
  });
}

// Event to unsubscribe private chat stream
class CancelStream extends PickedInquiriesDartEvent {
  final String channelUUID;

  const CancelStream(
    this.channelUUID,
  );
}
