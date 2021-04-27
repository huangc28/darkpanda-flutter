class Bank {
  const Bank({
    this.accountName,
    this.bankCode,
    this.accoutNumber,
  });

  final String accountName;
  final String bankCode;
  final int accoutNumber;

  static Bank fromJson(Map<String, dynamic> data) {
    return Bank(
      accountName: data['account_name'],
      bankCode: data['bank_code'],
      accoutNumber: data['account_number'],
    );
  }
}
