class Location {
  const Location({
    this.latitude,
    this.longtitude,
  });

  final double longtitude;
  final double latitude;

  // The argument `data` is a map of following structure:
  // {
  //   'lat': 37.422xxx,
  //   'lng': -122.xxxx.
  // }
  factory Location.fromMap(Map<String, dynamic> data) {
    if (!data.containsKey('lat')) {
      throw Exception(
          'lat does not exists. not able to transform to Location model');
    }

    if (!data.containsKey('lng')) {
      throw Exception(
          'lng does not exists. not able to transform to Location model');
    }

    return Location(
      latitude: data['lat'] ?? 0.0,
      longtitude: data['lng'] ?? 0.0,
    );
  }
}
