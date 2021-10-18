part of 'update_female_inquiry_bloc.dart';

class UpdateFemaleInquiryState<E extends AppBaseException> extends Equatable {
  const UpdateFemaleInquiryState._({
    this.status,
    this.error,
    this.inquiryStreamMap,
    this.femaleUser,
  });

  final AsyncLoadingStatus status;
  final E error;
  final FemaleUser femaleUser;

  /// This map keeps track of those inquiry record with status `asking`
  /// on firestore document. The app would react state change on the inquiry made by female or male user.
  final Map<String, StreamSubscription> inquiryStreamMap;

  UpdateFemaleInquiryState.initial()
      : this._(
          status: AsyncLoadingStatus.initial,
          inquiryStreamMap: {},
        );

  UpdateFemaleInquiryState.loading(UpdateFemaleInquiryState state)
      : this._(
          status: AsyncLoadingStatus.loading,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  UpdateFemaleInquiryState.loadFailed(UpdateFemaleInquiryState state, E error)
      : this._(
          status: AsyncLoadingStatus.error,
          error: error,
          inquiryStreamMap: state.inquiryStreamMap,
        );

  UpdateFemaleInquiryState.loaded(
    UpdateFemaleInquiryState state, {
    Map<String, StreamSubscription<DocumentSnapshot>> inquiryStreamMap,
    FemaleUser femaleUser,
  }) : this._(
          status: AsyncLoadingStatus.done,
          inquiryStreamMap: inquiryStreamMap ?? state.inquiryStreamMap,
          femaleUser: femaleUser ?? state.femaleUser,
        );

  UpdateFemaleInquiryState.putInquiries(
    UpdateFemaleInquiryState state, {
    FemaleUser femaleUser,
  }) : this._(
          status: state.status,
          inquiryStreamMap: state.inquiryStreamMap,
          femaleUser: femaleUser ?? state.femaleUser,
        );

  UpdateFemaleInquiryState.clearState(UpdateFemaleInquiryState state)
      : this._(
          status: AsyncLoadingStatus.initial,
          inquiryStreamMap: {},
          femaleUser: null,
        );

  @override
  List<Object> get props => [
        status,
        error,
        inquiryStreamMap,
        femaleUser,
      ];
}
