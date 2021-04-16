part of 'get_inquiry_bloc.dart';

class GetInquiryState extends Equatable {
  final AsyncLoadingStatus status;

  const GetInquiryState._({
    this.status,
  });

  GetInquiryState.init()
      : this._(
          status: AsyncLoadingStatus.initial,
        );

  GetInquiryState.loading()
      : this._(
          status: AsyncLoadingStatus.loading,
        );

  GetInquiryState.error()
      : this._(
          status: AsyncLoadingStatus.error,
        );

  GetInquiryState.done()
      : this._(
          status: AsyncLoadingStatus.done,
        );

  @override
  List<Object> get props => [];
}
