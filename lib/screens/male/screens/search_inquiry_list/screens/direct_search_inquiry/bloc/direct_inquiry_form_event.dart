part of 'direct_inquiry_form_bloc.dart';

abstract class DirectInquiryFormEvent extends Equatable {
  const DirectInquiryFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitDirectInquiryForm extends DirectInquiryFormEvent {
  const SubmitDirectInquiryForm(this.inquiryForms);

  final InquiryForms inquiryForms;

  @override
  List<Object> get props => [this.inquiryForms];
}
