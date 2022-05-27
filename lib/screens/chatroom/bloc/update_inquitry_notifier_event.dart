part of 'update_inquitry_notifier_bloc.dart';

abstract class UpdateInquiryNotifierEvent extends Equatable {
  const UpdateInquiryNotifierEvent(this.message);

  final UpdateInquiryMessage message;

  @override
  List<Object> get props => [
        message,
      ];
}

class UpdateInquiryConfirmed extends UpdateInquiryNotifierEvent {
  const UpdateInquiryConfirmed(UpdateInquiryMessage message) : super(message);
}
