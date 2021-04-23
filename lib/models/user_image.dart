import 'dart:io';

class UserImage {
  final String url;
  final File fileName;

  const UserImage({this.url, this.fileName});

  Map<String, dynamic> toJson() => {
        'url': url,
        'file_name': fileName,
      };
}
