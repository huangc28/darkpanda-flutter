part of 'verify_bank_bloc.dart';

abstract class VerifyBankEvent extends Equatable {
  const VerifyBankEvent();

  @override
  List<Object> get props => [];
}

class VerifyBank extends VerifyBankEvent {
  final String uuid;
  final String accountName;
  final String bankCode;
  final int accoutNumber;

  const VerifyBank({
    this.uuid,
    this.accountName,
    this.bankCode,
    this.accoutNumber,
  });
}
