part of 'search_inquiry_form_bloc.dart';

class SearchInquiryFormState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final CreateInquiryResponse createInquiryResponse;

  const SearchInquiryFormState._({
    this.error,
    this.status,
    this.createInquiryResponse,
  });

  /// Bloc yields following states
  SearchInquiryFormState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          createInquiryResponse: null,
        );

  SearchInquiryFormState.loading(SearchInquiryFormState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          createInquiryResponse: state.createInquiryResponse,
        );

  SearchInquiryFormState.error(SearchInquiryFormState state, {E err})
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  SearchInquiryFormState.done(
    SearchInquiryFormState state, {
    CreateInquiryResponse createInquiryResponse,
  }) : this._(
          status: AsyncLoadingStatus.done,
          createInquiryResponse:
              createInquiryResponse ?? state.createInquiryResponse,
        );

  @override
  List<Object> get props => [
        error,
        status,
        createInquiryResponse,
      ];
}
