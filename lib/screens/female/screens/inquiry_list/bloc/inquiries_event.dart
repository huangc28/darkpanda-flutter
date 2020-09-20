part of 'inquiries_bloc.dart';

abstract class InquiriesEvent extends Equatable {
  const InquiriesEvent();

  @override
  List<Object> get props => [];
}

/// FetchInquiries emitted by man.
/// @TODOs
///   - coordination should be included in payload
class FetchInquiries extends InquiriesEvent {}
