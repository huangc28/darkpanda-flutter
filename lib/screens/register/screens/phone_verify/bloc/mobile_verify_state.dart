part of 'mobile_verify_bloc.dart';

enum MobileVerifyStatus {
  unknown,
  verifying,
  verifyFailed,
  verified,
}

class MobileVerifyState<Error extends AppBaseException> extends Equatable {
  final MobileVerifyStatus status;
  final Error error;
  final String authToken;

  const MobileVerifyState._({
    this.status: MobileVerifyStatus.unknown,
    this.error,
    this.authToken,
  });

  const MobileVerifyState.unknown()
      : this._(
          status: MobileVerifyStatus.unknown,
        );

  const MobileVerifyState.verifying()
      : this._(
          status: MobileVerifyStatus.verifying,
        );

  const MobileVerifyState.verifyFailed(Error error)
      : this._(
          status: MobileVerifyStatus.verifyFailed,
          error: error,
        );

  const MobileVerifyState.verifiedSuccess(String authToken)
      : this._(
          authToken: authToken,
        );

  @override
  List<Object> get props => [status, error];
}
