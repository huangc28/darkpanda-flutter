import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/models/update_inquiry_message.dart';

class UpdateInquiryBubble extends StatelessWidget {
  const UpdateInquiryBubble({
    this.message,
    this.isMe = false,
    this.onTapMessage,
  });

  final UpdateInquiryMessage message;
  final bool isMe;
  final ValueChanged<UpdateInquiryMessage> onTapMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        top: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message.username + ' 已送出交易邀請',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(106, 109, 137, 1),
                ),
              ),

              // Display clickable message bubble
            ],
          ),
          InkWell(
            onTap: () {
              onTapMessage(message);
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.50,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(119, 81, 255, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fact_check,
                      color: Colors.white,
                      size: 19.0,
                    ),
                    SizedBox(width: 3),
                    Text("點擊開啟服務細節", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
