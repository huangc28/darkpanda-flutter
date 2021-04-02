import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';

import '../../../models/inquiry.dart';

part 'inquiry_grid_inquiry_detail.dart';
part 'inquiry_grid_actions.dart';

class InquiryGrid extends StatelessWidget {
  const InquiryGrid({
    Key key,
    @required this.onTapAvatar,
    @required this.onTapChat,
    this.inquiry,
  }) : super(key: key);

  final Inquiry inquiry;
  final ValueChanged<String> onTapAvatar;

  /// Girl is interested in this inquiry and want to start an inquiry chat
  /// with the guy.
  final ValueChanged<String> onTapChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(
        top: 12,
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
        children: [
          InquiryDetail(
            inquiry: inquiry,
          ),
          InquiryGridActions(
            onTapChat: onTapChat,
            inquiry: inquiry,
          )
        ],
      ),
    );
  }
}
