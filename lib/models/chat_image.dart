import 'package:equatable/equatable.dart';

class ChatImage extends Equatable {
  ChatImage({
    this.thumbnails,
    this.originals,
  });

  final List<dynamic> thumbnails;
  final List<dynamic> originals;

  factory ChatImage.fromMap(Map<String, dynamic> data) {
    List<dynamic> thumbnailsList = [];
    List<dynamic> originalsList = [];

    if (data.containsKey('thumbnails')) {
      thumbnailsList = data['thumbnails'].map<dynamic>((msg) {
        return msg;
      }).toList();
    }

    if (data.containsKey('originals')) {
      originalsList = data['originals'].map<dynamic>((msg) {
        return msg;
      }).toList();
    }

    return ChatImage(
      thumbnails: thumbnailsList,
      originals: originalsList,
    );
  }

  Map<String, dynamic> toMap() => {
        'thumbnails': thumbnails,
        'originals': originals,
      };

  List<Object> get props => [
        thumbnails,
        originals,
      ];
}
