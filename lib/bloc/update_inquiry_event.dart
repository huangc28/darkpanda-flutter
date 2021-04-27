part of 'update_inquiry_bloc.dart';

abstract class UpdateInquiryEvent extends Equatable {
  const UpdateInquiryEvent();

  @override
  List<Object> get props => [];
}

class UpdateInquiry extends UpdateInquiryEvent {
  const UpdateInquiry({
    this.serviceSettings,
  });

  final ServiceSettings serviceSettings;
}
