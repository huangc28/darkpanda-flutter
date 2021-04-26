part of 'load_bank_status_bloc.dart';

class LoadBankStatusState<E extends AppBaseException> extends Equatable {
  const LoadBankStatusState._({
    this.status,
    this.bankStatusDetail,
    this.error,
  });

  final AsyncLoadingStatus status;
  final BankStatusDetail bankStatusDetail;
  final E error;

  LoadBankStatusState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          bankStatusDetail: null,
        );

  LoadBankStatusState.loading(LoadBankStatusState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          bankStatusDetail: state.bankStatusDetail,
        );

  const LoadBankStatusState.loadFailed({
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const LoadBankStatusState.loaded({
    BankStatusDetail bankStatusDetail,
  }) : this._(
          status: AsyncLoadingStatus.done,
          bankStatusDetail: bankStatusDetail,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
