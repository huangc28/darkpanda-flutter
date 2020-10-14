import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:darkpanda_flutter/models/user_image.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    this.userImages,
    this.initialPage,
  });

  final List<UserImage> userImages;
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image gallery'),
      ),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            items: userImages
                .map(
                  (item) => Container(
                    child: Image.network(
                      item.url,
                      fit: BoxFit.cover,
                      height: height,
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              initialPage: initialPage,
              enableInfiniteScroll: false,
            ),
          );
        },
      ),
    );
  }
}
