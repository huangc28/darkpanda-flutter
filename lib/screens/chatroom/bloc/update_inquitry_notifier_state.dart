part of 'update_inquitry_notifier_bloc.dart';

abstract class UpdateInquiryNotifierState extends Equatable {
  const UpdateInquiryNotifierState(this.message);

  final UpdateInquiryMessage message;

  @override
  List<Object> get props => [
        message,
      ];
}

class UpdateInquiryNotifierInitial extends UpdateInquiryNotifierState {
  const UpdateInquiryNotifierInitial() : super(null);
}

class UpdateInquiryNotify extends UpdateInquiryNotifierState {
  const UpdateInquiryNotify(UpdateInquiryMessage message) : super(message);
}
