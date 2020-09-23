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

  /// Indicates that there are more inquires to load for the next page.
  final bool hasMore;
  final Error error;

  const InquiriesState._({
    this.status,
    this.inquiries,
    this.currentPage,
    this.hasMore,
    this.error,
  });

  InquiriesState.initial()
      : this._(
          status: FetchInquiryStatus.initial,
          inquiries: [],
          currentPage: 0,
          hasMore: true,
        );

  InquiriesState.fetching(InquiriesState state)
      : this._(
          status: FetchInquiryStatus.fetching,
          inquiries: state.inquiries,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
        );

  InquiriesState.fetchFailed(
    InquiriesState state, {
    Error error,
  }) : this._(
          status: FetchInquiryStatus.fetchFailed,
          inquiries: state.inquiries,
          currentPage: state.currentPage,
          error: error ?? state.error,
          hasMore: state.hasMore,
        );

  InquiriesState.fetched(
    InquiriesState state, {
    List<Inquiry> inquiries,
    int currentPage,
    bool hasMore,
  }) : this._(
          status: FetchInquiryStatus.fetched,
          inquiries: inquiries ?? state.inquiries,
          currentPage: currentPage ?? state.currentPage,
          hasMore: hasMore ?? state.hasMore,
        );

  @override
  List<Object> get props => [
        status,
        inquiries,
        error,
      ];
}
