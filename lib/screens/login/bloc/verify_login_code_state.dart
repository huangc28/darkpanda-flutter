part of 'verify_login_code_bloc.dart';

class VerifyLoginCodeState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;

  /// We need this piece of information to direct user to proper app entry.
  final Gender gender;

  const VerifyLoginCodeState._({
    this.status,
    this.error,
    this.gender,
  });

  const VerifyLoginCodeState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const VerifyLoginCodeState.verifying()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const VerifyLoginCodeState.verifyFailed({E error})
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
        );

  const VerifyLoginCodeState.verified({Gender gender})
      : this._(
          status: AsyncLoadingStatus.done,
          gender: gender,
        );

  @override
  List<Object> get props => [status, error, gender];
}
