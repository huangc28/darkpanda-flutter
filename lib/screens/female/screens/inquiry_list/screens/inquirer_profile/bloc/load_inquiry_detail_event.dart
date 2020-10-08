part of 'load_inquiry_detail_bloc.dart';

abstract class FetchInquiryDetailEvent extends Equatable {
  const FetchInquiryDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchInquiryDetail extends FetchInquiryDetailEvent {}
