part of 'verify_bank_bloc.dart';

abstract class VerifyBankEvent extends Equatable {
  const VerifyBankEvent();

  @override
  List<Object> get props => [];
}

class VerifyBank extends VerifyBankEvent {
  final String uuid;
  final String bankName;
  final String branch;
  final String accoutNumber;

  const VerifyBank({
    this.uuid,
    this.bankName,
    this.branch,
    this.accoutNumber,
  });
}
