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

  /// This map keeps track of those inquiry record with status `asking`
  /// on firestore document. The app would react state change on the inquiry made by female or male user.
  final Map<String, StreamSubscription> inquiryStreamMap;

  const InquiriesState._({
    this.status,
    this.inquiries,
    this.currentPage,
    this.hasMore,
    this.error,
    this.inquiryStreamMap,
  });

  InquiriesState.initial()
      : this._(
          status: FetchInquiryStatus.initial,
          inquiries: [],
          currentPage: 0,
          hasMore: true,
          inquiryStreamMap: {},
        );

  InquiriesState.fetching(InquiriesState state)
      : this._(
          status: FetchInquiryStatus.fetching,
          inquiries: state.inquiries,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
          inquiryStreamMap: state.inquiryStreamMap,
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
          inquiryStreamMap: state.inquiryStreamMap,
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
          inquiryStreamMap: state.inquiryStreamMap,
        );

  InquiriesState.putInquiries(
    InquiriesState state, {
    List<Inquiry> inquiries,
  }) : this._(
          status: state.status,
          inquiries: inquiries ?? state.inquiries,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  InquiriesState.putInquiryStreamMap(
    InquiriesState state, {
    Map<String, StreamSubscription> inquiryStreamMap,
  }) : this._(
          status: state.status,
          inquiries: state.inquiries,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
          inquiryStreamMap: inquiryStreamMap ?? state.inquiryStreamMap,
        );

  @override
  List<Object> get props => [
        status,
        inquiries,
        error,
        inquiryStreamMap,
      ];
}
