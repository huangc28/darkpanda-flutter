class NegotiatingServiceDetail {
  NegotiatingServiceDetail({
    this.serviceUUID,
    this.channelUUID,
    this.counterPartUUID,
    this.inquiryUUID,
    this.serviceType,
    this.address,
    this.serviceTime,
    this.duration,
    this.price,
    this.username,
  });

  String serviceUUID;
  String channelUUID;
  String counterPartUUID;
  String inquiryUUID;

  String serviceType;
  String address;
  DateTime serviceTime;
  Duration duration;
  double price;
  String username;
}
