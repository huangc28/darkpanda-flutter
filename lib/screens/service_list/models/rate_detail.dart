class RateDetail {
  RateDetail({
    this.raterUsername,
    this.raterUuid,
    this.raterAvatarUrl,
    this.rating,
    this.comments,
    this.createdAt,
  });

  String raterUsername;
  String raterUuid;
  String raterAvatarUrl;
  int rating;
  String comments;
  String createdAt;

  Map<String, dynamic> toMap() => {
        'rater_username': raterUsername,
        'rater_uuid': raterUuid,
        'rater_avatar_url': raterAvatarUrl,
        'rating': rating,
        'comments': comments,
        'created_at': createdAt,
      };

  factory RateDetail.fromMap(Map<String, dynamic> data) {
    return RateDetail(
      raterUsername: data['rater_username'],
      raterUuid: data['rater_uuid'],
      raterAvatarUrl: data['rater_avatar_url'],
      rating: data['rating'],
      comments: data['comments'],
      createdAt: data['created_at'],
    );
  }

  factory RateDetail.fromJson(Map<String, dynamic> data) {
    return RateDetail(
      raterUsername: data['rater_username'],
      raterUuid: data['rater_uuid'],
      raterAvatarUrl: data['rater_avatar_url'],
      rating: data['rating'],
      comments: data['comments'],
      createdAt: data['created_at'],
    );
  }
}
