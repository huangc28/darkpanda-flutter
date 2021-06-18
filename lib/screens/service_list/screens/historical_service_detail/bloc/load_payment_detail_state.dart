part of 'load_payment_detail_bloc.dart';

class LoadPaymentDetailState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final PaymentDetail paymentDetail;
  final E error;

  const LoadPaymentDetailState._({
    this.status,
    this.paymentDetail,
    this.error,
  });

  LoadPaymentDetailState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          paymentDetail: null,
        );

  LoadPaymentDetailState.loading(LoadPaymentDetailState state)
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  LoadPaymentDetailState.loadSuccess(LoadPaymentDetailState state,
      {PaymentDetail paymentDetail, RateDetail rateDetail})
      : this._(status: AsyncLoadingStatus.done, paymentDetail: paymentDetail);

  LoadPaymentDetailState.loadFailed(LoadPaymentDetailState state, E err)
      : this._(
          status: AsyncLoadingStatus.error,
        );

  @override
  List<Object> get props => [
        status,
        paymentDetail,
        error,
      ];
}
