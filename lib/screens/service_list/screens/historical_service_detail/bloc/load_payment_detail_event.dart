part of 'load_payment_detail_bloc.dart';

abstract class LoadPaymentDetailEvent extends Equatable {
  const LoadPaymentDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadPaymentDetail extends LoadPaymentDetailEvent {
  const LoadPaymentDetail({this.serviceUuid});
  final String serviceUuid;

  @override
  List<Object> get props => [serviceUuid];
}
