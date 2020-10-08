part of 'load_inquiry_detail_bloc.dart';

enum LoadInquiryDetailStatus {
  initial,
  loading,
  loadFailed,
  loaded,
}

class LoadInquiryDetailState extends Equatable {
  const LoadInquiryDetailState._({
    this.status,
  });

  final LoadInquiryDetailStatus status;

  const LoadInquiryDetailState.initial()
      : this._(
          status: LoadInquiryDetailStatus.initial,
        );

  const LoadInquiryDetailState.loading()
      : this._(
          status: LoadInquiryDetailStatus.initial,
        );

  const LoadInquiryDetailState.loadFailed()
      : this._(
          status: LoadInquiryDetailStatus.loadFailed,
        );

  const LoadInquiryDetailState.loaded()
      : this._(
          status: LoadInquiryDetailStatus.loaded,
        );

  @override
  List<Object> get props => [
        status,
      ];
}
