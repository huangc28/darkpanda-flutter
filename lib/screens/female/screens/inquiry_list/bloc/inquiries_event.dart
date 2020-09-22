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
  final int offset;

  /// Specify the number of page to fetch from the API.
  final int nextPage;

  const FetchInquiries({
    this.perPage = 7,
    this.offset = 0,
    this.nextPage = 1,
  }) : assert(nextPage > 0);
}
