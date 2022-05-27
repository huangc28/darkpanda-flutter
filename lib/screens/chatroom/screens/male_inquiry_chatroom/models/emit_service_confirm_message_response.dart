import 'package:equatable/equatable.dart';

class EmitServiceConfirmMessageResponse extends Equatable {
  const EmitServiceConfirmMessageResponse({
    this.channelUuid,
    this.serviceChannelUuid,
    this.qrCodeUrl,
  });

  final String channelUuid;
  final String serviceChannelUuid;
  final String qrCodeUrl;

  static EmitServiceConfirmMessageResponse fromMap(Map<String, dynamic> data) {
    return EmitServiceConfirmMessageResponse(
      channelUuid: data['channel_uuid'] ?? '',
      serviceChannelUuid: data['service_channel_uuid'] ?? '',
      qrCodeUrl: data['qrcode_url'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        channelUuid,
        serviceChannelUuid,
        qrCodeUrl,
      ];
}
