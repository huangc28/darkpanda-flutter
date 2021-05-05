part of 'load_my_dp_bloc.dart';

abstract class LoadMyDpEvent extends Equatable {
  const LoadMyDpEvent();

  @override
  List<Object> get props => [];
}

class LoadMyDp extends LoadMyDpEvent {
  const LoadMyDp({
    this.uuid,
  });

  final String uuid;
}
