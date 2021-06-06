part of 'search_inquiry_form_bloc.dart';

abstract class SearchInquiryFormEvent extends Equatable {
  const SearchInquiryFormEvent();

  @override
  List<Object> get props => [];
}

class SubmitSearchInquiryForm extends SearchInquiryFormEvent {
  const SubmitSearchInquiryForm(this.inquiryForms);

  final InquiryForms inquiryForms;

  @override
  List<Object> get props => [this.inquiryForms];
}
