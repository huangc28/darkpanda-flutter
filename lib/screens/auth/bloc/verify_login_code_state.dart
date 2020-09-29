part of 'verify_login_code_bloc.dart';

enum VerifyLoginCodeStatus {
  initial,
  verifying,
  verifyFailed,
  verified,
}

class VerifyLoginCodeState<E extends AppBaseException> extends Equatable {
  final VerifyLoginCodeStatus status;
  final E error;

  const VerifyLoginCodeState._({
    this.status,
    this.error,
  });

  const VerifyLoginCodeState.initial()
      : this._(
          status: VerifyLoginCodeStatus.initial,
        );

  const VerifyLoginCodeState.verifying()
      : this._(
          status: VerifyLoginCodeStatus.verifying,
        );

  const VerifyLoginCodeState.verifyFailed({E error})
      : this._(
          status: VerifyLoginCodeStatus.verifyFailed,
          error: error,
        );

  const VerifyLoginCodeState.verified()
      : this._(
          status: VerifyLoginCodeStatus.verified,
        );

  @override
  List<Object> get props => [status];
}
