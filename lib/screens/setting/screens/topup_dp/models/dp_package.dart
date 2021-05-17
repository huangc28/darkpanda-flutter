class DpPackage {
  DpPackage({
    this.id,
    this.dpCoin,
    this.cost,
    this.currency,
  });

  int id;
  int dpCoin;
  int cost;
  String currency;

  Map<String, dynamic> toJson() => {
        'id': id,
        'dp_coin': dpCoin,
        'cost': cost,
        'currency': currency,
      };

  factory DpPackage.fromJson(Map<String, dynamic> data) {
    return DpPackage(
      id: data['id'],
      dpCoin: data['dp_coin'],
      cost: data['cost'],
      currency: data['currency'],
    );
  }
}

class DpPackageList {
  List<DpPackage> packages;

  DpPackageList({this.packages});

  Map<String, dynamic> toJson() => {
        'packages': packages,
      };

  factory DpPackageList.fromJson(Map<String, dynamic> data) {
    List<DpPackage> packageList = [];

    if (data['packages'] != null) {
      packageList = data['packages'].map<DpPackage>((v) {
        return DpPackage.fromJson(v);
      }).toList();
    }

    return DpPackageList(
      packages: packageList,
    );
  }
}
