// TODO what the fuck is route types? remove it!
import 'package:darkpanda_flutter/enums/route_types.dart';

class FemaleInquiryChatroomScreenArguments {
  final String channelUUID;
  final String inquiryUUID;
  final String counterPartUUID;
  final String serviceType;
  final RouteTypes routeTypes;
  final String serviceUUID;

  FemaleInquiryChatroomScreenArguments({
    this.channelUUID,
    this.inquiryUUID,
    this.counterPartUUID,
    this.serviceType,
    this.routeTypes,
    this.serviceUUID,
  })  : assert(channelUUID != null),
        assert(inquiryUUID != null),
        assert(counterPartUUID != null),
        assert(serviceType != null),
        assert(serviceUUID != null);
}
