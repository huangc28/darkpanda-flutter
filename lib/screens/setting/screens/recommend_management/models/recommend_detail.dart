import 'package:darkpanda_flutter/screens/setting/screens/recommend_management/models/recommend_user.dart';

class RecommendDetail {
  const RecommendDetail({
    this.referralCode,
    this.recommendUserLists,
  });

  final String referralCode;
  final List<RecommendUser> recommendUserLists;

  static RecommendDetail fromJson(Map<String, dynamic> data) {
    List<RecommendUser> recommendUserLists = [];

    if (data.containsKey('recharge_user_list')) {
      recommendUserLists =
          data['recharge_user_list'].map<RecommendUser>((recommendUser) {
        return RecommendUser.fromJson(recommendUser);
      }).toList();
    }

    return RecommendDetail(
        referralCode: data['referral_code'],
        recommendUserLists: recommendUserLists);
  }
}
