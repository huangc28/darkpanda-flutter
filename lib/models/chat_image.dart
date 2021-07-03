import 'package:equatable/equatable.dart';

class ChatImage extends Equatable {
  final String imageUrl;

  const ChatImage({
    this.imageUrl,
  });

  Map<String, dynamic> toMap() => {
        'image_url': imageUrl,
      };

  List<Object> get props => [
        imageUrl,
      ];
}
