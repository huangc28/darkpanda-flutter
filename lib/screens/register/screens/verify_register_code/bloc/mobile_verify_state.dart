part of 'mobile_verify_bloc.dart';

class MobileVerifyState<Error extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final Error error;
  final String authToken;

  const MobileVerifyState._({
    this.status: AsyncLoadingStatus.initial,
    this.error,
    this.authToken,
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
