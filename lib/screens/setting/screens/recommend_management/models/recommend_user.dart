class RecommendUser {
  const RecommendUser({
    this.name,
    this.avatarUrl,
    this.price,
    this.countTrade,
  });

  final String name;
  final String avatarUrl;
  final double price;
  final int countTrade;

  static RecommendUser fromJson(Map<String, dynamic> data) {
    return RecommendUser(
      name: data['name'],
      avatarUrl: data['avatar_url'],
      price: data['price'],
      countTrade: data['count_trade'],
    );
  }
}
