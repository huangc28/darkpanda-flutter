class PaymentCard {
  PaymentCard({
    this.cardNumber,
    this.name,
    this.month,
    this.year,
    this.cvv,
    this.prime,
    this.packageId,
  });

  String cardNumber;
  String name;
  String month;
  String year;
  int cvv;
  String prime;
  int packageId;

  Map<String, dynamic> toJson() => {
        'card_number': cardNumber,
        'name': name,
        'month': month,
        'year': year,
        'cvv': cvv,
        'prime': prime,
        'package_id': packageId,
      };
}
