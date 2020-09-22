part of 'load_more_inquiries_bloc.dart';

enum LoadMoreInquiryStatus {
  initial,
  loading,
  loaded,
  loadFailed,
}

class LoadMoreInquiriesState<Error extends AppBaseException> extends Equatable {
  final LoadMoreInquiryStatus status;
  final Error error;

  const LoadMoreInquiriesState._({
    this.status,
    this.error,
  });

  const LoadMoreInquiriesState.initial()
      : this._(status: LoadMoreInquiryStatus.initial);

  const LoadMoreInquiriesState.loading()
      : this._(status: LoadMoreInquiryStatus.loading);

  const LoadMoreInquiriesState.loaded()
      : this._(status: LoadMoreInquiryStatus.loaded);

  const LoadMoreInquiriesState.loadFailed(Error error)
      : this._(
          status: LoadMoreInquiryStatus.loadFailed,
          error: error,
        );

  @override
  List<Object> get props => [status];
}
