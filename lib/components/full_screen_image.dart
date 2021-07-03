import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({
    Key key,
    this.imageUrl,
    this.tag = "123",
  }) : super(key: key);

  final String imageUrl;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: SizedBox(
              width: SizeConfig.screenWidth,
              child: ClipRRect(
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
