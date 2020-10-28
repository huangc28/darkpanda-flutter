import 'package:enum_to_string/enum_to_string.dart';

import 'package:darkpanda_flutter/enums/service_types.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:darkpanda_flutter/enums/premium_types.dart';

// DEBUG 1 PickupInquiryState {
//   "uuid":"a5b9080b-d574-4fa0-87a7-5f873aa38aff",
//   "budget":84680,
//   "service_type":"sex",
//   "inquiry_status":"chatting",
//   "created_at":"2020-10-26T03:59:27.98452Z",
//   "channel_uuid":"private_chat:gxatDfpGR",
//   "inquirer":{"uuid":"6b6d0ee5-3d3a-44e3-80c9-00eeb1565b6f","username":"fuker_1","premium_type":"normal"}}
class PickedInquirer {
  final String uuid;
  final String username;
  final PremiumTypes premiumType;

  const PickedInquirer({
    this.uuid,
    this.username,
    this.premiumType,
  });
}

class PickedInquiry {
  final String uuid;
  final double budget;
  final ServiceTypes serviceType;
  final InquiryStatus inquiryStatus;
  final DateTime createdAt;
  final String channelUUID;

  const PickedInquiry({
    this.uuid,
    this.budget,
    this.serviceType,
    this.inquiryStatus,
    this.createdAt,
    this.channelUUID,
  });

  factory PickedInquiry.fromMap(Map<String, dynamic> data) => PickedInquiry(
        uuid: data['uuid'],
        budget: data['budget'].toDouble(),
        serviceType:
            EnumToString.fromString(ServiceTypes.values, data['service_type']),
        inquiryStatus: EnumToString.fromString(
            InquiryStatus.values, data['inquiry_status']),
        createdAt: DateTime.parse(data['created_at']),
        channelUUID: data['channel_uuid'],
      );
}
