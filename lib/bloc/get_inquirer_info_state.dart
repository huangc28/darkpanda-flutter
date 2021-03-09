part of 'get_inquirer_info_bloc.dart';

enum GetInquirerStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class GetInquirerInfoState extends Equatable {
  const GetInquirerInfoState._({
    this.status,
  });

  const GetInquirerInfoState.initial()
      : this._(
          status: GetInquirerStatus.initial,
        );

  final GetInquirerStatus status;

  @override
  List<Object> get props => [
        status,
      ];
}
