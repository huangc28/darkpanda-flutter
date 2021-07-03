import 'package:darkpanda_flutter/util/try_parse_to_date_time.dart';

import 'message.dart';

class ImageMessage extends Message {
  ImageMessage({
    this.content,
    this.from,
    this.imageUrls,
    this.createdAt,
  });

  final String content;
  final String from;
  final List<dynamic> imageUrls;
  final DateTime createdAt;

  static DateTime fieldToDateTime(dynamic field) => tryParseToDateTime(field);

  factory ImageMessage.fromMap(Map<String, dynamic> data) {
    List<dynamic> images = [];

    if (data.containsKey('image_urls')) {
      images = data['image_urls'].map<dynamic>((msg) {
        return msg;
      }).toList();
    }

    return ImageMessage(
      content: data['content'] ?? '',
      from: data['from'] ?? '',
      imageUrls: images,
      createdAt: ImageMessage.fieldToDateTime(data['created_at']),
    );
  }

  @override
  List<Object> get props => [
        content,
        from,
        imageUrls,
        createdAt,
      ];
}
