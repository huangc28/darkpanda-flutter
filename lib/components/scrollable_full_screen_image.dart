import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollableFullScreenImage extends StatefulWidget {
  const ScrollableFullScreenImage({
    Key key,
    this.tag = "123",
    this.images,
    this.index = 0,
  }) : super(key: key);

  final String tag;
  final List<UserImage> images;
  final int index;

  @override
  _ScrollableFullScreenImageState createState() =>
      _ScrollableFullScreenImageState();
}

class _ScrollableFullScreenImageState extends State<ScrollableFullScreenImage> {
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ScrollablePositionedList.builder(
        initialScrollIndex: widget.index,
        itemScrollController: itemScrollController,
        itemCount: widget.images.length,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Center(
              child: Hero(
                tag: widget.tag + index.toString(),
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  child: ClipRRect(
                    child: Image.network(widget.images[index].url),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
