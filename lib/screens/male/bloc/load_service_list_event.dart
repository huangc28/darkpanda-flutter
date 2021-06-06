part of 'load_service_list_bloc.dart';

abstract class LoadServiceListEvent extends Equatable {
  const LoadServiceListEvent();

  @override
  List<Object> get props => [];
}

class LoadServiceList extends LoadServiceListEvent {
  const LoadServiceList();
}

class ClearServiceListState extends LoadServiceListEvent {
  const ClearServiceListState();
}
