class BankStatusDetail {
  const BankStatusDetail({
    this.bankName,
    this.branch,
    this.accoutNumber,
    this.verifyStatus,
  });

  final String bankName;
  final String branch;
  final String accoutNumber;
  final String verifyStatus;

  static BankStatusDetail fromJson(Map<String, dynamic> data) {
    return BankStatusDetail(
      bankName: data['bank_name'],
      branch: data['branch'],
      accoutNumber: data['account_number'],
      verifyStatus: data['verify_status'],
    );
  }
}
