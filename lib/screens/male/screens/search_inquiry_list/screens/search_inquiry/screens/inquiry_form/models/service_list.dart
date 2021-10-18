class ServiceList {
  ServiceList({
    this.serviceNames,
  });

  List<ServiceName> serviceNames;

  factory ServiceList.fromMap(Map<String, dynamic> data) {
    List<ServiceName> serviceList = [];

    if (data['service_names'] != null) {
      serviceList = data['service_names'].map<ServiceName>((v) {
        return ServiceName.fromMap(v);
      }).toList();
    }

    return ServiceList(
      serviceNames: serviceList,
    );
  }

  Map<String, dynamic> toMap() => {
        'service_names': serviceNames,
      };
}

class ServiceName {
  ServiceName({
    this.name,
  });

  String name;

  ServiceName.fromMap(Map<String, dynamic> data) : name = data['name'];

  Map<String, dynamic> toMap() => {
        'name': name,
      };
}
