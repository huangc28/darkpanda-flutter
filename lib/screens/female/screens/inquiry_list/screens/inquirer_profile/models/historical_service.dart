// {"services":[{"uuid":"364a7d54-8a3d-4bf6-b49e-4ca7a80b9a69","price":24760,"service_type":"completed","service_status":"","created_at":"2020-10-12T04:58:42.85763Z"}]}
class HistoricalService {
  const HistoricalService({
    this.uuid,
    this.price,
    this.serviceType,
    this.serviceStatus,
    this.createdAt,
  });

  final String uuid;
  final double price;
  final String serviceType;
  final String serviceStatus;
  final DateTime createdAt;

  factory HistoricalService.fromMap(Map<String, dynamic> data) {
    return HistoricalService(
      uuid: data['uuid'],
      price: data['price'].toDouble(),
      serviceType: data['service_type'],
      serviceStatus: data['service_status'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
