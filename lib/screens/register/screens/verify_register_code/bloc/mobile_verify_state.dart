part of 'mobile_verify_bloc.dart';

class MobileVerifyState<Error extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final Error error;

  /// We need this information to direct the user to proper app entry.
  final Gender gender;

  const MobileVerifyState._({
    this.status: AsyncLoadingStatus.initial,
    this.error,
    this.gender,
  });

  const MobileVerifyState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          error: null,
        );

  MobileVerifyState.loading(MobileVerifyState m)
      : this._(
          gender: m.gender,
          status: AsyncLoadingStatus.loading,
          error: null,
        );

  MobileVerifyState.error(MobileVerifyState m)
      : this._(
          status: AsyncLoadingStatus.error,
          error: m.error,
        );

  MobileVerifyState.done(MobileVerifyState state)
      : this._(
          status: AsyncLoadingStatus.done,
          gender: state.gender,
          error: null,
        );

  factory MobileVerifyState.copyFrom(
    MobileVerifyState state, {
    Error error,
    Gender gender,
  }) {
    return MobileVerifyState._(
      error: error ?? state.error,
      gender: gender ?? state.gender,
    );
  }

  @override
  List<Object> get props => [
        status,
        error,
        gender,
      ];
}
