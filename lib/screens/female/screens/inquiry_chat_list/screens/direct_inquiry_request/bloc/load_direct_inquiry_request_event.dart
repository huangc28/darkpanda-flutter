part of 'load_direct_inquiry_request_bloc.dart';

abstract class LoadDirectInquiryRequestEvent extends Equatable {
  const LoadDirectInquiryRequestEvent();

  @override
  List<Object> get props => [];
}

/// FetchInquiries emitted by man.
/// @TODOs
///   - coordination and pagination info should be included in the payload.
class FetchDirectInquiries extends LoadDirectInquiryRequestEvent {
  final int perPage;

  /// Specify the number of page to fetch from the API.
  final int nextPage;

  const FetchDirectInquiries({
    this.perPage = 6,
    this.nextPage = 1,
  }) : assert(nextPage > 0);
}

class LoadMorehDirectInquiries extends LoadDirectInquiryRequestEvent {
  final int perPage;

  const LoadMorehDirectInquiries({
    this.perPage = 6,
  });
}

class AppendInquiries extends LoadDirectInquiryRequestEvent {
  final List<DirectInquiryRequests> inquiries;

  const AppendInquiries({
    this.inquiries,
  });
}

class UpdateInquiryStatus extends LoadDirectInquiryRequestEvent {
  final String inquiryUuid;
  final InquiryStatus inquiryStatus;
  final String channelUuid;
  final String serviceUuid;

  const UpdateInquiryStatus({
    this.inquiryUuid,
    this.inquiryStatus,
    this.channelUuid,
    this.serviceUuid,
  });
}

class RemoveInquiry extends LoadDirectInquiryRequestEvent {
  final String inquiryUuid;

  const RemoveInquiry({
    this.inquiryUuid,
  });
}

class AddInquirySubscription extends LoadDirectInquiryRequestEvent {
  final String uuid;

  const AddInquirySubscription({
    this.uuid,
  });
}
