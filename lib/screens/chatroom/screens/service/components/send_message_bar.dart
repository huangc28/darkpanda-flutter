import 'package:flutter/material.dart';

class SendMessageBar extends StatefulWidget {
  const SendMessageBar({
    @required this.onSend,
    this.onImageGallery,
    this.onCamera,
    this.editMessageController,
  });

  final VoidCallback onSend;
  final VoidCallback onImageGallery;
  final VoidCallback onCamera;

  final TextEditingController editMessageController;

  @override
  _SendMessageBarState createState() => _SendMessageBarState();
}

class _SendMessageBarState extends State<SendMessageBar> {
  bool _showSendButton = false;

  Widget _buildImageGalleryIconButton() {
    return IconButton(
      icon: Image.asset(
        'lib/screens/chatroom/assets/image_gallery.png',
      ),
      iconSize: 22,
      color: Colors.white,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: widget.onImageGallery,
    );
  }

  Widget _buildSendMessageIconButton() {
    return IconButton(
      icon: Icon(Icons.send),
      iconSize: 22,
      color: Colors.white,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: widget.onSend,
    );
  }

  Widget _buildCameraIconButton() {
    return IconButton(
      icon: Icon(
        Icons.camera_alt_rounded,
      ),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      iconSize: 22,
      color: Colors.white,
      onPressed: widget.onCamera,
    );
  }

  Widget _inputTextField() {
    return Expanded(
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: widget.editMessageController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 2, left: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(40),
          )),
          filled: true,
          fillColor: Colors.black38,
          hintText: '輸入訊息',
        ),
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          color: Colors.white,
        ),
        onChanged: (String v) {
          //  If v has value and is not an empty string, display the send icon.
          setState(() {
            _showSendButton = v.isNotEmpty;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      height: 68,
      color: Color.fromRGBO(31, 30, 56, 1),
      child: Row(
        children: <Widget>[
          // Display camera icon
          _buildCameraIconButton(),

          // Display image Gallery icon.
          _buildImageGalleryIconButton(),
          _inputTextField(),

          // Only display sending icon when user is typing.
          _showSendButton
              ? _buildSendMessageIconButton()
              : SizedBox(
                  width: 25,
                ),
        ],
      ),
    );
  }
}
