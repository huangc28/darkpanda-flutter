class VerifyBank {
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

  factory VerifyBank.fromJson(Map<String, dynamic> data) {
    return VerifyBank(
      accountName: data['account_name'],
      bankCode: data['bank_code'],
      accoutNumber: data['account_number'],
    );
  }

  VerifyBank copyWith({
    String uuid,
    String accountName,
    String bankCode,
    int accoutNumber,
  }) {
    return VerifyBank(
      uuid: uuid ?? this.uuid,
      accountName: accountName ?? this.accountName,
      bankCode: bankCode ?? this.bankCode,
      accoutNumber: accoutNumber ?? this.accoutNumber,
    );
  }

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'bank_code': bankCode,
        'account_number': accoutNumber,
      };
}
