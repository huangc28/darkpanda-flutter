part of 'load_more_inquiries_bloc.dart';

class LoadMoreInquiriesEvent extends Equatable {
  const LoadMoreInquiriesEvent();

  @override
  List<Object> get props => [];
}

class LoadMoreInquiries extends LoadMoreInquiriesEvent {
  final int perPage;
  final int nextPage;

  const LoadMoreInquiries({
    this.perPage = 7,
    this.nextPage,
  }) : assert(nextPage != null);
}
