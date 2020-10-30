part of 'picked_inquiries_dart_bloc.dart';

class PickedInquiriesDartState<E extends AppBaseException> extends Equatable {
  final List<PickedInquiry> pickedInquiries;
  final E error;

  // Map of channel UUID and stream.
  final Map<String, StreamSubscription> privateChatStreamMap;

  const PickedInquiriesDartState._({
    this.pickedInquiries,
    this.privateChatStreamMap,
    this.error,
  });

  PickedInquiriesDartState.init()
      : this._(
          pickedInquiries: [],
          privateChatStreamMap: {},
        );

  PickedInquiriesDartState.updatePickedInquiries(List<PickedInquiry> inquiries)
      : this._(
          pickedInquiries: inquiries,
        );

  PickedInquiriesDartState.updatePrivateChatStreamMap(
    PickedInquiriesDartState state,
    Map<String, StreamSubscription> map,
  ) : this._(
          pickedInquiries: state.pickedInquiries,
          privateChatStreamMap: map,
        );

  PickedInquiriesDartState.failed(PickedInquiriesDartState state, E error)
      : this._(
          pickedInquiries: state.pickedInquiries,
          privateChatStreamMap: state.privateChatStreamMap,
          error: error,
        );

  @override
  List<Object> get props => [
        pickedInquiries,
        privateChatStreamMap,
      ];
}
