part of 'verify_bank_bloc.dart';

abstract class VerifyBankEvent extends Equatable {
  const VerifyBankEvent();

  @override
  List<Object> get props => [];
}

class AccountNameChanged extends VerifyBankEvent {
  const AccountNameChanged(this.accountName);

  final String accountName;

  @override
  List<Object> get props => [accountName];
}

class BankCodeChanged extends VerifyBankEvent {
  const BankCodeChanged(this.bankCode);

  final String bankCode;

  @override
  List<Object> get props => [bankCode];
}

class AccoutNumberChanged extends VerifyBankEvent {
  const AccoutNumberChanged(this.accoutNumber);

  final int accoutNumber;

  @override
  List<Object> get props => [accoutNumber];
}

class UpdateVerifyBank extends VerifyBankEvent {
  const UpdateVerifyBank();

  @override
  List<Object> get props => [];
}
