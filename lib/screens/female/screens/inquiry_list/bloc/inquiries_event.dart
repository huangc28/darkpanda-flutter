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

class LoadMoreInquiries extends InquiriesEvent {
  final int perPage;

  const LoadMoreInquiries({
    this.perPage = 7,
  });
}

class AppendInquiries extends InquiriesEvent {
  final List<Inquiry> inquiries;

  const AppendInquiries({
    this.inquiries,
  });
}

class UpdateInquiryStatus extends InquiriesEvent {
  final String inquiryUuid;
  final InquiryStatus inquiryStatus;

  const UpdateInquiryStatus({
    this.inquiryUuid,
    this.inquiryStatus,
  });
}

class RemoveInquiry extends InquiriesEvent {
  final String inquiryUuid;

  const RemoveInquiry({
    this.inquiryUuid,
  });
}

class AddInquirySubscription extends InquiriesEvent {
  final String uuid;

  const AddInquirySubscription({
    this.uuid,
  });
}
