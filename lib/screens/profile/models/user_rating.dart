class UserRating {
  final String username;
  final int rate;
  final DateTime createdAt;
  final String comment;
  final String avatarUrl;

  UserRating({
    this.username,
    this.rate,
    this.createdAt,
    this.comment,
    this.avatarUrl,
  });

  UserRating.fromJson(Map<String, dynamic> data)
      : username = data['username'],
        rate = data['rating'],
        createdAt = DateTime.parse(data['created_at']),
        comment = data['comments'],
        avatarUrl = data['avatar_url'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'rating': rate,
        'created_at': createdAt.toIso8601String(),
        'comments': comment,
        'avatar_url': avatarUrl,
      };
}
