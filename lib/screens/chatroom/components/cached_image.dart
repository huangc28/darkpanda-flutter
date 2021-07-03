import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
