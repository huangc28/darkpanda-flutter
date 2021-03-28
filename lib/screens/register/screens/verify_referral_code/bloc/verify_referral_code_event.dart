part of 'verify_referral_code_bloc.dart';

class VerifyReferralCodeEvent extends Equatable {
  const VerifyReferralCodeEvent({
    this.referralCode,
    this.username,
  });

  final String referralCode;
  final String username;

  @override
  List<Object> get props => [];
}
