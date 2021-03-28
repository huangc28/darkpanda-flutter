part of 'verify_referral_code_bloc.dart';

class VerifyReferralCodeState<E extends AppBaseException> extends Equatable {
  const VerifyReferralCodeState._({
    this.status,
    this.verifyRefCodeError,
    this.verifyUsernameError,
  });

  final AsyncLoadingStatus status;

  final E verifyRefCodeError;
  final E verifyUsernameError;

  VerifyReferralCodeState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  VerifyReferralCodeState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
          verifyRefCodeError: null,
          verifyUsernameError: null,
        );

  VerifyReferralCodeState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  VerifyReferralCodeState.error({
    E verifyRefCodeError,
    E verifyUsernameError,
  }) : this._(
          status: AsyncLoadingStatus.error,
          verifyRefCodeError: verifyRefCodeError,
          verifyUsernameError: verifyUsernameError,
        );

  @override
  List<Object> get props => [
        status,
        verifyRefCodeError,
        verifyUsernameError,
      ];
}
