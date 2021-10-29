import 'package:flutter/material.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/components/direct_inquiry_request_detail.dart';
import 'package:darkpanda_flutter/screens/female/screens/inquiry_chat_list/screens/direct_inquiry_request/models/direct_inquiry_requests.dart';

class DirectInquiryRequestGrid extends StatelessWidget {
  const DirectInquiryRequestGrid({
    Key key,
    this.inquiry,
    this.onTapAgreeToChat,
    this.onTapSkip,
    this.onTapViewProfile,
    this.onTapStartToChat,
    this.agreeToChatIsLoading = false,
    this.inquiryUuid = "",
  }) : super(key: key);

  final DirectInquiryRequests inquiry;
  final ValueChanged<String> onTapAgreeToChat;
  final ValueChanged<String> onTapSkip;
  final ValueChanged<String> onTapViewProfile;
  final ValueChanged<String> onTapStartToChat;
  final bool agreeToChatIsLoading;
  final String inquiryUuid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.016),
      child: LimitedBox(
        child: Container(
          padding: EdgeInsets.only(
            top: SizeConfig.screenHeight * 0.022, //12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color.fromRGBO(106, 109, 137, 1),
            ),
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Color.fromRGBO(31, 30, 56, 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DirectInquiryRequestDetail(
                inquiry: inquiry,
                onTapSkip: onTapSkip,
                onTapAgreeToChat: onTapAgreeToChat,
                onTapViewProfile: onTapViewProfile,
                onTapStartToChat: onTapStartToChat,
                agreeToChatIsLoading: agreeToChatIsLoading,
                inquiryUuid: inquiryUuid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
