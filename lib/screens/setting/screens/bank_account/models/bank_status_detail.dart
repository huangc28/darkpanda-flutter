class BankStatusDetail {
  const BankStatusDetail({
    this.accountName,
    this.bankCode,
    this.accoutNumber,
    this.status,
  });

  final String accountName;
  final String bankCode;
  final int accoutNumber;
  final String status;

  static BankStatusDetail fromJson(Map<String, dynamic> data) {
    return BankStatusDetail(
      accountName: data['account_name'],
      bankCode: data['bank_code'],
      accoutNumber: data['account_number'],
      status: data['status'],
    );
  }
}
