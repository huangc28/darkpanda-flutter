part of 'load_direct_inquiry_request_bloc.dart';

class LoadDirectInquiryRequestState<Error extends AppBaseException>
    extends Equatable {
  final AsyncLoadingStatus status;
  final List<DirectInquiryRequests> inquiries;
  final int currentPage;

  /// Indicates that there are more inquires to load for the next page.
  final bool hasMore;
  final Error error;

  /// This map keeps track of those inquiry record with status `asking`
  /// on firestore document. The app would react state change on the inquiry made by female or male user.
  final Map<String, StreamSubscription> inquiryStreamMap;

  const LoadDirectInquiryRequestState._({
    this.status,
    this.inquiries,
    this.currentPage,
    this.hasMore,
    this.error,
    this.inquiryStreamMap,
  });

  LoadDirectInquiryRequestState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          inquiries: [],
          currentPage: 0,
          hasMore: true,
          inquiryStreamMap: {},
        );

  LoadDirectInquiryRequestState.fetching(LoadDirectInquiryRequestState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          inquiries: state.inquiries,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  LoadDirectInquiryRequestState.fetchFailed(
    LoadDirectInquiryRequestState state, {
    Error error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          inquiries: state.inquiries,
          currentPage: state.currentPage,
          error: error ?? state.error,
          hasMore: state.hasMore,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  LoadDirectInquiryRequestState.fetched(
    LoadDirectInquiryRequestState state, {
    List<DirectInquiryRequests> inquiries,
    int currentPage,
    bool hasMore,
    Map<String, StreamSubscription<DocumentSnapshot>> inquiryStreamMap,
  }) : this._(
          status: AsyncLoadingStatus.done,
          inquiries: inquiries ?? state.inquiries,
          currentPage: currentPage ?? state.currentPage,
          hasMore: hasMore ?? state.hasMore,
          inquiryStreamMap: inquiryStreamMap ?? state.inquiryStreamMap,
        );

  LoadDirectInquiryRequestState.putInquiries(
    LoadDirectInquiryRequestState state, {
    List<DirectInquiryRequests> inquiries,
  }) : this._(
          status: state.status,
          inquiries: inquiries ?? state.inquiries,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  LoadDirectInquiryRequestState.putInquiryStreamMap(
    LoadDirectInquiryRequestState state, {
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
