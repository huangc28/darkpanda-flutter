import 'package:equatable/equatable.dart';

class RecommendDetail extends Equatable {
  const RecommendDetail({
    this.referralCode,
  });

  final String referralCode;

  static RecommendDetail fromJson(Map<String, dynamic> data) {
    return RecommendDetail(referralCode: data['referral_code']);
  }

  @override
  List<Object> get props => [
        referralCode,
      ];
}
