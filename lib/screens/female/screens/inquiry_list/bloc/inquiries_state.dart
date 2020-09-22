part of 'inquiries_bloc.dart';

enum FetchInquiryStatus {
  initial,
  fetching,
  fetchFailed,
  fetched,
}

class InquiriesState<Error extends AppBaseException> extends Equatable {
  final FetchInquiryStatus status;
  final List<Inquiry> inquiries;
  final int currentPage;
  final Error error;

  const InquiriesState._({
    this.status,
    this.inquiries,
    this.currentPage,
    this.error,
  });

  InquiriesState.initial()
      : this._(
          status: FetchInquiryStatus.initial,
          inquiries: [],
          currentPage: 0,
        );

  InquiriesState.fetching(InquiriesState state)
      : this._(
          status: FetchInquiryStatus.fetching,
          inquiries: state.inquiries,
        );

  InquiriesState.fetchFailed(
    InquiriesState state, {
    Error error,
  }) : this._(
          status: FetchInquiryStatus.fetchFailed,
          inquiries: state.inquiries,
          error: error ?? state.error,
        );

  InquiriesState.fetched(
    InquiriesState state, {
    List<Inquiry> inquiries,
    int currentPage,
  }) : this._(
          status: FetchInquiryStatus.fetched,
          inquiries: inquiries ?? state.inquiries,
          currentPage: currentPage ?? state.currentPage,
        );

  @override
  List<Object> get props => [
        status,
        inquiries,
        error,
      ];
}
