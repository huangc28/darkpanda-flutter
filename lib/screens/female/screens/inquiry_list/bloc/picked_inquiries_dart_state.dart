part of 'picked_inquiries_dart_bloc.dart';

class PickedInquiriesDartState extends Equatable {
  final List<PickedInquiry> pickedInquiries;

  const PickedInquiriesDartState._({
    this.pickedInquiries,
  });

  PickedInquiriesDartState.init()
      : this._(
          pickedInquiries: [],
        );

  PickedInquiriesDartState.updatePickedInquiries(List<PickedInquiry> inquiries)
      : this._(
          pickedInquiries: inquiries,
        );

  @override
  List<Object> get props => [
        pickedInquiries,
      ];
}
