part of 'add_user_service_bloc.dart';

abstract class AddUserServiceEvent extends Equatable {
  const AddUserServiceEvent();

  @override
  List<Object> get props => [];
}

class AddUserService extends AddUserServiceEvent {
  const AddUserService({
    this.name,
    this.description,
    this.price,
  });

  final String name;
  final String description;
  final double price;

  @override
  List<Object> get props => [
        this.name,
        this.description,
        this.price,
      ];
}
