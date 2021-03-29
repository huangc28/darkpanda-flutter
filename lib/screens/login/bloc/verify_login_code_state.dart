part of 'verify_login_code_bloc.dart';

enum VerifyLoginCodeStatus {
  initial,
  verifying,
  verifyFailed,
  verified,
}

class VerifyLoginCodeState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;

  const VerifyLoginCodeState._({
    this.status,
    this.error,
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

  const VerifyLoginCodeState.verified()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [status];
}
