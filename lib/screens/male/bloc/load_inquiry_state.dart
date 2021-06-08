part of 'load_inquiry_bloc.dart';

class LoadInquiryState<E extends AppBaseException> extends Equatable {
  const LoadInquiryState._({
    this.status,
    this.activeInquiry,
    this.error,
    this.inquiryStreamMap,
  });

  final AsyncLoadingStatus status;
  final ActiveInquiry activeInquiry;
  final E error;

  final Map<String, StreamSubscription> inquiryStreamMap;

  LoadInquiryState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          activeInquiry: null,
          inquiryStreamMap: {},
        );

  LoadInquiryState.loading(LoadInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          activeInquiry: state.activeInquiry,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  LoadInquiryState.loadFailed(
    LoadInquiryState state, {
    E error,
  }) : this._(
          status: AsyncLoadingStatus.error,
          error: error,
          activeInquiry: state.activeInquiry,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  LoadInquiryState.loaded(
    LoadInquiryState state, {
    ActiveInquiry activeInquiry,
    Map<String, StreamSubscription<DocumentSnapshot>> inquiryStreamMap,
  }) : this._(
          status: AsyncLoadingStatus.done,
          activeInquiry: activeInquiry ?? state.activeInquiry,
          inquiryStreamMap: inquiryStreamMap ?? state.inquiryStreamMap,
        );

  LoadInquiryState.clearState()
      : this._(
          activeInquiry: null,
          status: AsyncLoadingStatus.initial,
        );

  LoadInquiryState.putInquiries(
    LoadInquiryState state, {
    ActiveInquiry activeInquiry,
  }) : this._(
          status: state.status,
          activeInquiry: activeInquiry ?? state.activeInquiry,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  LoadInquiryState.putInquiryStreamMap(
    LoadInquiryState state, {
    Map<String, StreamSubscription> inquiryStreamMap,
  }) : this._(
          status: state.status,
          activeInquiry: state.activeInquiry,
          inquiryStreamMap: inquiryStreamMap ?? state.inquiryStreamMap,
        );

  @override
  List<Object> get props => [
        status,
        activeInquiry,
        error,
        inquiryStreamMap,
      ];
}
