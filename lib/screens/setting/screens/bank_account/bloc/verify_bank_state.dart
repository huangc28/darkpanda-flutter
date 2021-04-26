part of 'verify_bank_bloc.dart';

class VerifyBankState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final Bank bank;

  const VerifyBankState._({
    this.error,
    this.status,
    this.bank,
  });

  /// Bloc yields following states
  const VerifyBankState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const VerifyBankState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const VerifyBankState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const VerifyBankState.done(Bank bank)
      : this._(
          status: AsyncLoadingStatus.done,
          bank: bank,
        );

  @override
  List<Object> get props => [
        error,
        status,
        bank,
      ];
}
