part of 'verify_bank_bloc.dart';

class VerifyBankState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final models.VerifyBank verifyBank;

  final String uuid;
  final String accountName;
  final String bankCode;
  final int accoutNumber;

  const VerifyBankState._({
    this.verifyBank,
    this.status,
    this.error,
    this.uuid,
    this.accountName,
    this.bankCode,
    this.accoutNumber,
  });

  VerifyBankState copyWith({
    String uuid,
    String accountName,
    String bankCode,
    int accoutNumber,
  }) {
    return VerifyBankState._(
      uuid: uuid ?? this.uuid,
      accountName: accountName ?? this.accountName,
      bankCode: bankCode ?? this.bankCode,
      accoutNumber: accoutNumber ?? this.accoutNumber,
    );
  }

  /// Bloc yields following states
  VerifyBankState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          error: null,
          verifyBank: null,
        );

  VerifyBankState.loading(VerifyBankState m)
      : this._(
          status: AsyncLoadingStatus.loading,
          verifyBank: m.verifyBank,
        );

  VerifyBankState.error(VerifyBankState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
          verifyBank: m.verifyBank,
        );

  VerifyBankState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  factory VerifyBankState.copyFrom(
    VerifyBankState state, {
    E error,
    models.VerifyBank verifyBank,
  }) {
    return VerifyBankState._(
      error: error ?? state.error,
      verifyBank: verifyBank ?? state.verifyBank,
    );
  }

  @override
  List<Object> get props => [
        error,
        status,
        verifyBank,
        uuid,
        accountName,
        bankCode,
        accoutNumber,
      ];
}
