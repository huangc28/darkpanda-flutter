part of 'redirector_bloc.dart';

abstract class RedirectorBlocState extends Equatable {
  const RedirectorBlocState();

  @override
  List<Object> get props => [];
}

class RedirectorBlocInitial extends RedirectorBlocState {}
