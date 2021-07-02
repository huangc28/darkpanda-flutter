part of 'verify_change_mobile_bloc.dart';

class VerifyChangeMobileState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const VerifyChangeMobileState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  VerifyChangeMobileState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  VerifyChangeMobileState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  VerifyChangeMobileState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  VerifyChangeMobileState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
