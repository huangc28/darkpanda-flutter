import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/bloc/get_inquiry_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

class SendMessageBar extends StatefulWidget {
  const SendMessageBar({
    @required this.onSend,
    @required this.onEditInquiry,
    this.editMessageController,
    this.disable = false,
  });

  final VoidCallback onSend;
  final VoidCallback onEditInquiry;

  final TextEditingController editMessageController;
  final bool disable;

  @override
  _SendMessageBarState createState() => _SendMessageBarState();
}

class _SendMessageBarState extends State<SendMessageBar> {
  bool _showSendButton = false;

  Widget _buildEditInquiryButton() {
    return BlocBuilder<GetInquiryBloc, GetInquiryState>(
      builder: (context, state) {
        // Allow user to edit inquiry detail only when done loading
        var disable =
            widget.disable || state.status == AsyncLoadingStatus.loading;

        var opacity = disable ? 0.4 : 1.0;

        return Opacity(
          opacity: opacity,
          child: IconButton(
            icon: Image.asset(
              'lib/screens/chatroom/assets/send_message.png',
            ),
            iconSize: 22,
            color: Colors.white,
            onPressed: disable ? null : widget.onEditInquiry,
          ),
        );
      },
    );
  }

  Widget _buildImageGalleryIconButton() {
    return IconButton(
      icon: Image.asset(
        'lib/screens/chatroom/assets/image_gallery.png',
      ),
      iconSize: 22,
      color: Colors.white,
      onPressed: () {},
    );
  }

  Widget _buildSendMessageIconButton() {
    return IconButton(
      icon: Icon(Icons.send),
      iconSize: 22,
      color: Colors.white,
      onPressed: widget.onSend,
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
          _buildEditInquiryButton(),

          // Display image Gallery icon.
          _buildImageGalleryIconButton(),
          Expanded(
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
          ),

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
