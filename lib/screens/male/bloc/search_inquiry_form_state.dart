part of 'search_inquiry_form_bloc.dart';

class SearchInquiryFormState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;

  const SearchInquiryFormState._({
    this.error,
    this.status,
  });

  /// Bloc yields following states
  const SearchInquiryFormState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  const SearchInquiryFormState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  const SearchInquiryFormState.error(E err)
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  const SearchInquiryFormState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [
        error,
        status,
      ];
}
