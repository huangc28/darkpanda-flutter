part of 'load_bank_status_bloc.dart';

enum LoadBankStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class LoadBankStatusState<E extends AppBaseException> extends Equatable {
  const LoadBankStatusState._({
    this.status,
    this.bankStatusDetail,
    this.error,
  });

  final LoadBankStatus status;
  final BankStatusDetail bankStatusDetail;
  final E error;

  LoadBankStatusState.initial()
      : this._(
          status: LoadBankStatus.initial,
          bankStatusDetail: null,
        );

  LoadBankStatusState.loading(LoadBankStatusState state)
      : this._(
          status: LoadBankStatus.loading,
          bankStatusDetail: state.bankStatusDetail,
        );

  const LoadBankStatusState.loadFailed({
    E error,
  }) : this._(
          status: LoadBankStatus.loadFailed,
          error: error,
        );

  const LoadBankStatusState.loaded({
    BankStatusDetail bankStatusDetail,
  }) : this._(
          status: LoadBankStatus.loaded,
          bankStatusDetail: bankStatusDetail,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
