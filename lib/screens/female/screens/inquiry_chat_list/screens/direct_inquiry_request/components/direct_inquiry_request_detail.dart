import 'package:darkpanda_flutter/enums/inquiry_status.dart';
import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/models/direct_inquiry_requests.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/components/cancel_inquiry_confirmation_dialog.dart';

import 'package:darkpanda_flutter/components/user_avatar.dart';

class DirectInquiryRequestDetail extends StatelessWidget {
  const DirectInquiryRequestDetail({
    Key key,
    this.inquiry,
    this.onTapSkip,
    this.onTapViewProfile,
    this.onTapAgreeToChat,
    this.onTapStartToChat,
  }) : super(key: key);

  final DirectInquiryRequests inquiry;
  final ValueChanged<String> onTapAgreeToChat;
  final ValueChanged<String> onTapSkip;
  final ValueChanged<String> onTapViewProfile;
  final ValueChanged<String> onTapStartToChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: SizeConfig.screenWidth * 0.35,
          padding: EdgeInsets.only(
            left: SizeConfig.screenWidth * 0.07,
            right: SizeConfig.screenWidth * 0.06,
            bottom: SizeConfig.screenHeight * 0.014,
          ),
          child: InkWell(
            onTap: () {
              onTapViewProfile(inquiry.inquirerUuid);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Inquirer avatar
                UserAvatar(
                  inquiry.avatarUrl,
                  radius: SizeConfig.screenWidth * 0.08,
                ),

                SizedBox(
                  height: SizeConfig.screenHeight * 0.01, //10
                ),

                // Inquirer name
                Text(
                  inquiry.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: SizeConfig.screenWidth * 0.07,
              right: SizeConfig.screenWidth * 0.04,
              bottom: SizeConfig.screenHeight * 0.025,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                inquiry.inquiryStatus == InquiryStatus.chatting
                    ? _startToChatButton()
                    : _agreeToChatButton(),
                SizedBox(width: 10),
                inquiry.inquiryStatus == InquiryStatus.chatting
                    ? Container()
                    : _cancelButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _agreeToChatButton() {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: DPTextButton(
          theme: DPTextButtonThemes.deepGrey,
          onPressed: () {
            onTapAgreeToChat(inquiry.inquiryUuid);
          },
          text: '立即洽談',
        ),
      ),
    );
  }

  Widget _startToChatButton() {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: DPTextButton(
          theme: DPTextButtonThemes.purple,
          onPressed: () {
            onTapStartToChat(inquiry.inquiryUuid);
          },
          text: '開始洽談',
        ),
      ),
    );
  }

  Widget _cancelButton(context) {
    return Expanded(
      child: SizedBox(
        child: InkWell(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.06,
            child: Image.asset("lib/screens/male/assets/cancelButton.png"),
          ),
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CancelInquiryConfirmationDialog(
                  title: '確定跳過此男生？',
                  onCancel: '取消',
                  onConfirm: '確定跳過',
                );
              },
            ).then((value) {
              if (value) {
                onTapSkip(inquiry.inquiryUuid);
              }
            });
          },
        ),
      ),
    );
  }
}
