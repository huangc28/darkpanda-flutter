part of 'load_female_list_bloc.dart';

abstract class LoadFemaleListEvent extends Equatable {
  const LoadFemaleListEvent();

  @override
  List<Object> get props => [];
}

class LoadFemaleList extends LoadFemaleListEvent {
  const LoadFemaleList({
    this.perPage = 6,
    this.nextPage = 1,
  });

  final int perPage;
  final int nextPage;
}

class LoadMoreFemaleList extends LoadFemaleListEvent {
  final int perPage;

  const LoadMoreFemaleList({
    this.perPage = 6,
  });
}

// Update female profile in list after a service is made for the user.
class UpdateFemaleProfileInList extends LoadFemaleListEvent {
  final FemaleUser femaleUser;

  const UpdateFemaleProfileInList({
    this.femaleUser,
  });
}

class ClearFemaleListState extends LoadFemaleListEvent {
  const ClearFemaleListState();
}
