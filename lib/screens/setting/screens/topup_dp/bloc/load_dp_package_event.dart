part of 'load_dp_package_bloc.dart';

abstract class LoadDpPackageEvent extends Equatable {
  const LoadDpPackageEvent();

  @override
  List<Object> get props => [];
}

class LoadDpPackage extends LoadDpPackageEvent {
  const LoadDpPackage();
}

class ClearDpPackageState extends LoadDpPackageEvent {
  const ClearDpPackageState();
}
