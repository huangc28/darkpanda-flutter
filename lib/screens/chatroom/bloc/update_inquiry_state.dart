part of 'update_inquiry_bloc.dart';

abstract class UpdateInquiryState<E extends AppBaseException>
    extends Equatable {
  const UpdateInquiryState({
    this.status,
    this.error,
    this.serviceSettings,
  });

  final AsyncLoadingStatus status;
  final E error;
  final ServiceSettings serviceSettings;

  @override
  List<Object> get props => [
        status,
        error,
      ];
}

class UpdateInquiryInitial extends UpdateInquiryState {
  const UpdateInquiryInitial()
      : super(
          status: AsyncLoadingStatus.initial,
        );
}

class UpdateInquiryLoading extends UpdateInquiryState {
  const UpdateInquiryLoading()
      : super(
          status: AsyncLoadingStatus.loading,
        );
}

class UpdateInquiryError<E extends AppBaseException>
    extends UpdateInquiryState {
  const UpdateInquiryError(E error)
      : super(
          status: AsyncLoadingStatus.error,
          error: error,
        );
}

class UpdateInquiryDone extends UpdateInquiryState {
  const UpdateInquiryDone({ServiceSettings serviceSettings})
      : super(
          status: AsyncLoadingStatus.done,
          serviceSettings: serviceSettings,
        );
}
