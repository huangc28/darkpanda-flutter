class UserRating {
  final String username;
  final int rate;
  final DateTime rateDate;
  final String comment;

  UserRating({this.username, this.rate, this.rateDate, this.comment});

  UserRating.fromJson(Map<String, dynamic> data)
      : username = data['username'],
        rate = data['rate'],
        rateDate = data['rateDate'],
        comment = data['comment'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'rate': rate,
        'rateDate': rateDate.toIso8601String(),
        'comment': comment,
      };
}
