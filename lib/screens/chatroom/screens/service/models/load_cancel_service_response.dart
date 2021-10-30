import 'package:equatable/equatable.dart';
import 'package:darkpanda_flutter/enums/service_cancel_cause.dart';

class LoadCancelServiceResponse extends Equatable {
  LoadCancelServiceResponse({
    this.cancelCause,
  });

  final ServiceCancelCause cancelCause;

  @override
  List<Object> get props => [cancelCause];

  @override
  bool get stringify => true;

  LoadCancelServiceResponse copyWith({
    ServiceCancelCause cancelCause,
  }) {
    return LoadCancelServiceResponse(
      cancelCause: cancelCause ?? this.cancelCause,
    );
  }

  factory LoadCancelServiceResponse.fromMap(Map<String, dynamic> data) {
    String serviceCancelCause = data['cancel_cause'] as String;

    return LoadCancelServiceResponse(
      cancelCause: serviceCancelCause?.toServiceCancelCauseEnum(),
    );
  }
}
