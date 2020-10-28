part of 'pickup_inquiry_bloc.dart';

abstract class PickupInquiryEvent extends Equatable {
  const PickupInquiryEvent();

  @override
  List<Object> get props => [];
}

class PickupInquiry extends PickupInquiryEvent {
  final String uuid;

  const PickupInquiry({
    this.uuid,
  }) : assert(uuid != null);
}
