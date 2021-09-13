part of 'payment_complete_notifier_bloc.dart';

abstract class PaymentCompleteNotifierEvent extends Equatable {
  const PaymentCompleteNotifierEvent(this.message);

  final Message message;

  @override
  List<Object> get props => [message];
}

class NotifyPaymentCompleted extends PaymentCompleteNotifierEvent {
  const NotifyPaymentCompleted(Message message) : super(message);
}
