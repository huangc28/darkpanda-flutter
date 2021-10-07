part of 'load_female_list_bloc.dart';

abstract class LoadFemaleListEvent extends Equatable {
  const LoadFemaleListEvent();

  @override
  List<Object> get props => [];
}

class LoadFemaleList extends LoadFemaleListEvent {
  final String uuid;

  const LoadFemaleList({this.uuid});
}

class ClearFemaleListState extends LoadFemaleListEvent {
  const ClearFemaleListState();
}
