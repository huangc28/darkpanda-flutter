part of 'direct_inquiry_form_bloc.dart';

class DirectInquiryFormState<E extends AppBaseException> extends Equatable {
  final E error;
  final AsyncLoadingStatus status;
  final CreateInquiryResponse createInquiryResponse;

  const DirectInquiryFormState._({
    this.error,
    this.status,
    this.createInquiryResponse,
  });

  /// Bloc yields following states
  DirectInquiryFormState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          createInquiryResponse: null,
        );

  DirectInquiryFormState.loading(DirectInquiryFormState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          createInquiryResponse: state.createInquiryResponse,
        );

  DirectInquiryFormState.error(DirectInquiryFormState state, {E err})
      : this._(
          status: AsyncLoadingStatus.error,
          error: err,
        );

  DirectInquiryFormState.done(
    DirectInquiryFormState state, {
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
