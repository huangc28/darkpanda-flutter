class RechargeAmount {
  RechargeAmount({
    this.id,
    this.dpCoin,
    this.price,
  });

  final int id;
  final double dpCoin;
  final double price;

  factory RechargeAmount.fromJson(Map<String, dynamic> data) {
    return RechargeAmount(
      id: data['id'],
      dpCoin: data['dp_coin'],
      price: data['price'],
    );
  }
}
