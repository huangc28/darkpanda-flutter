import 'package:flutter/material.dart';

class SendMessageBar extends StatelessWidget {
  const SendMessageBar({
    this.onSend,
    this.editMessageController,
    this.disable = false,
  });

  final VoidCallback onSend;
  final TextEditingController editMessageController;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 60,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(0.0),
            width: 30,
            child: IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              controller: editMessageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: disable ? null : onSend,
          ),
        ],
      ),
    );
  }
}
