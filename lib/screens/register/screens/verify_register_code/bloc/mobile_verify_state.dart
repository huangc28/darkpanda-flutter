part of 'mobile_verify_bloc.dart';

class MobileVerifyState<Error extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final Error error;
  final String authToken;

  /// We need this information to direct the user to proper app entry.
  final Gender gender;

  const MobileVerifyState._({
    this.status: AsyncLoadingStatus.initial,
    this.error,
    this.authToken,
    this.gender,
  });

  const MobileVerifyState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          error: null,
          authToken: null,
        );

  MobileVerifyState.loading(MobileVerifyState m)
      : this._(
          status: AsyncLoadingStatus.loading,
          error: null,
          authToken: m.authToken,
        );

  MobileVerifyState.error(MobileVerifyState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
          authToken: m.authToken,
        );

  MobileVerifyState.done(MobileVerifyState state)
      : this._(
          status: AsyncLoadingStatus.done,
          authToken: state.authToken,
          error: null,
        );

  factory MobileVerifyState.copyFrom(
    MobileVerifyState state, {
    Error error,
    String authToken,
    Gender gender,
  }) {
    return MobileVerifyState._(
      error: error ?? state.error,
      authToken: authToken ?? state.authToken,
      gender: gender ?? state.gender,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        authToken,
        gender,
      ];
}
