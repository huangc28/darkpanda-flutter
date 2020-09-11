part of 'mobile_verify_bloc.dart';

abstract class MobileVerifyEvent extends Equatable {
  const MobileVerifyEvent();

  @override
  List<Object> get props => [];
}

class VerifyMobile extends MobileVerifyEvent {
  final String prefix;
  final int suffix;
  final String uuid;

  VerifyMobile({
    this.prefix,
    this.suffix,
    this.uuid,
  });
}
