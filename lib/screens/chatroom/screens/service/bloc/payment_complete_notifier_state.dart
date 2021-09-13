part of 'payment_complete_notifier_bloc.dart';

abstract class PaymentCompleteNotifierState extends Equatable {
  const PaymentCompleteNotifierState(this.message);

  final Message message;

  @override
  List<Object> get props => [
        message,
      ];
}

class PaymentCompleteNotifierInitial extends PaymentCompleteNotifierState {
  const PaymentCompleteNotifierInitial() : super(null);
}

class PaymentCompletedNotify extends PaymentCompleteNotifierState {
  const PaymentCompletedNotify(Message message) : super(message);
}
