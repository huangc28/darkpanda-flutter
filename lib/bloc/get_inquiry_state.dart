part of 'get_inquiry_bloc.dart';

class GetInquiryState<E extends AppBaseException> extends Equatable {
  final AsyncLoadingStatus status;
  final E error;
  final Inquiry inquiry;

  /// We will normalize response retrieved to [ServiceSettings]. We use
  /// [ServiceSettings] to display inquiry data on the service setting sheet.
  final ServiceSettings serviceSettings;

  const GetInquiryState._({
    this.status,
    this.error,
    this.inquiry,
    this.serviceSettings,
  });

  GetInquiryState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  GetInquiryState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  GetInquiryState.error(E error)
      : this._(status: AsyncLoadingStatus.error, error: error);

  GetInquiryState.done(ServiceSettings serviceSettings)
      : this._(
          status: AsyncLoadingStatus.done,
          serviceSettings: serviceSettings,
        );

  @override
  List<Object> get props => [
        status,
        error,
        inquiry,
        serviceSettings,
      ];
}
