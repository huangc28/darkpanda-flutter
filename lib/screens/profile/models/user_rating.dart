class UserRating {
  UserRating({
    this.raterUsername,
    this.raterUuid,
    this.rating,
    // this.createdAt,
    this.comment,
    this.raterAvatarUrl,
  });

  final String raterUsername;
  final String raterUuid;
  final int rating;
  // final DateTime createdAt;
  final String comment;
  final String raterAvatarUrl;

  UserRating.fromMap(Map<String, dynamic> data)
      : raterUsername = data['rater_username'],
        raterUuid = data['rater_uuid'],
        rating = data['rating'],
        // createdAt = DateTime.parse(data['created_at']),
        comment = data['comment'],
        raterAvatarUrl = data['rater_avatar_url'];

  Map<String, dynamic> toMap() => {
        'username': raterUsername,
        'rater_uuid': raterUuid,
        'rating': rating,
        // 'created_at': createdAt.toIso8601String(),
        'comment': comment,
        'rater_avatar_url': raterAvatarUrl,
      };
}

class UserRatings {
  UserRatings({this.userRatings});

  final List<UserRating> userRatings;

  factory UserRatings.fromMap(Map<String, dynamic> data) {
    List<UserRating> rateList = [];

    if (data['ratings'] != null) {
      rateList = data['ratings'].map<UserRating>((v) {
        return UserRating.fromMap(v);
      }).toList();
    }

    return UserRatings(
      userRatings: rateList,
    );
  }
}
