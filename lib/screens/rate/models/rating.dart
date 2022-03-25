class Rating {
  final String serviceUuid;
  final int rating;
  final String comment;

  Rating({
    this.serviceUuid,
    this.rating,
    this.comment,
  });

  factory Rating.copyFrom(
    String serviceUuid,
    int rating,
    String comment,
  ) {
    return Rating(
      serviceUuid: serviceUuid ?? serviceUuid,
      rating: rating ?? rating,
      comment: comment ?? comment,
    );
  }

  factory Rating.fromJson(Map<String, dynamic> data) {
    return Rating(
      serviceUuid: data['service_uuid'],
      rating: data['rating'],
      comment: data['comment'],
    );
  }

  Map<String, dynamic> toJson() => {
        'service_uuid': serviceUuid,
        'rating': rating,
        'comment': comment,
      };
}
