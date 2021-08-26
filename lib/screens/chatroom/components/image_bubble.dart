import 'package:darkpanda_flutter/screens/chatroom/components/cached_image.dart';
import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/image_message.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({
    @required this.message,
    this.isMe = false,
    this.onEnlarge,
  });

  final ImageMessage message;
  final bool isMe;
  final VoidCallback onEnlarge;

  Widget _buildMineBubble(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(119, 81, 255, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: _buildDefaultImage(message.imageUrls),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherBubble(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage("assets/default_avatar.png"),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(55, 55, 77, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _buildDefaultImage(message.imageUrls),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultImage(List<dynamic> imageUrls) {
    return GestureDetector(
      onTap: onEnlarge,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedImage(url: imageUrls[0]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isMe ? _buildMineBubble(context) : _buildOtherBubble(context);
  }
}
