part of 'inquiries_bloc.dart';

abstract class InquiriesEvent extends Equatable {
  const InquiriesEvent();

  @override
  List<Object> get props => [];
}

/// FetchInquiries emitted by man.
/// @TODOs
///   - coordination and pagination info should be included in the payload.
class FetchInquiries extends InquiriesEvent {
  final int perPage;

  /// Specify the number of page to fetch from the API.
  final int nextPage;

  const FetchInquiries({
    this.perPage = 7,
    this.nextPage = 1,
  }) : assert(nextPage > 0);
}

class AppendInquiries extends InquiriesEvent {
  final List<Inquiry> inquiries;

  const AppendInquiries({this.inquiries});
}
