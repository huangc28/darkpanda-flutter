part of 'load_bank_status_bloc.dart';

abstract class LoadBankStatusEvent extends Equatable {
  const LoadBankStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadBank extends LoadBankStatusEvent {
  const LoadBank({
    this.uuid,
  });

  final String uuid;
}
