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
          error: null,
          authToken: null,
        );

  MobileVerifyState.verifying(MobileVerifyState m)
      : this._(
          status: MobileVerifyStatus.verifying,
          error: null,
          authToken: m.authToken,
        );

  MobileVerifyState.verifyFailed(MobileVerifyState m)
      : this._(
          status: MobileVerifyStatus.verifyFailed,
          error: m.error,
          authToken: m.authToken,
        );

  MobileVerifyState.verifiedSuccess(MobileVerifyState state)
      : this._(
          authToken: state.authToken,
          error: null,
        );

  factory MobileVerifyState.copyFrom(
    MobileVerifyState state, {
    MobileVerifyStatus status,
    Error error,
    String authToken,
  }) {
    return MobileVerifyState._(
      error: error ?? state.error,
      authToken: authToken ?? state.authToken,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        authToken,
      ];
}
