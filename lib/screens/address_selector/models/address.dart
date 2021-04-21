class AddressComponent {
  const AddressComponent({
    this.longName,
    this.shortName,
  });

  final String longName;
  final String shortName;

  factory AddressComponent.fromMap(Map<String, dynamic> data) {
    return AddressComponent(
      shortName: data['short_name'],
      longName: data['long_name'],
    );
  }
}

class Address {
  const Address({
    this.address,
  });

  final String address;

  /// This factory method compose the [address] string by iterating
  /// components reversely.
  factory Address.fromAddressComponentArray(List<AddressComponent> components) {
    return Address();
  }
}
