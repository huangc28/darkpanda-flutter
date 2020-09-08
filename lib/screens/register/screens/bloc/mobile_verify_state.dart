part of 'mobile_verify_bloc.dart';

enum MobileVerifyStatus {
  unknown,
  verifying,
  verifyFailed,
  verified,
}

class MobileVerifyState extends Equatable {
  final MobileVerifyStatus status;
  final Error error;

  const MobileVerifyState._({
    this.status: MobileVerifyStatus.unknown,
    this.error,
  });

  const MobileVerifyState.unknown()
      : this._(
          status: MobileVerifyStatus.unknown,
        );

  const MobileVerifyState.verifying()
      : this._(
          status: MobileVerifyStatus.verifying,
        );

  const MobileVerifyState.verifyFailed()
      : this._(status: MobileVerifyStatus.verifyFailed);

  @override
  List<Object> get props => [];
}

// class MobileVerifyInitial extends MobileVerifyState {}

// class MobileVerifying extends MobileVerifyState {}

// class MobileVerifyFailed extends MobileVerifyState {
//   final Error error;
//   MobileVerifyFailed({this.error});
// }

// class MobileVerified extends MobileVerifyState
