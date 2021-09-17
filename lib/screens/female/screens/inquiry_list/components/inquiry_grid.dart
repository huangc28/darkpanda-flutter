import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/enums/service_types.dart';
import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/inquiry_status.dart';

import '../../../../../models/inquiry.dart';

part 'inquiry_grid_inquiry_detail.dart';
part 'inquiry_grid_actions.dart';

class InquiryGrid extends StatelessWidget {
  const InquiryGrid({
    Key key,
    @required this.onTapPickup,
    @required this.onTapClear,
    @required this.onTapCheckProfile,
    @required this.onTapStartChat,
    this.inquiry,
    this.isLoading = false,
    this.inquiryUuid = "",
  }) : super(key: key);

  final Inquiry inquiry;

  /// Girl is interested in this inquiry and want to start an inquiry chat
  /// with the guy. The girl still has to wait for the reply of the man.
  final ValueChanged<String> onTapPickup;

  /// When male user denies to chat with the girl. Girl can hide that record by
  /// clicking on `clear` button on the inquiry grid to remove this grid from
  /// the inquiry list.
  final ValueChanged<String> onTapClear;

  /// Female user can view male user profile on inquiry list. User uuid will be provided
  /// to `onTapCheckProfile` in order to fetch user profile.
  final ValueChanged<String> onTapCheckProfile;

  /// Male user agrees to chat with the female user. By pressing the `onTapChatting` button,
  /// Female user would be redirect to inquiry chatroom.
  final ValueChanged<Inquiry> onTapStartChat;

  final bool isLoading;
  final String inquiryUuid;

  @override
  Widget build(BuildContext context) {
    // Limited box give container a constraint when the constraint isn't set by the parent.
    // In this case, `ListView` does not have constraint on it's scrolling direction.
    // @Ref: https://www.youtube.com/watch?v=uVki2CIzBTs&ab_channel=Flutter
    return Padding(
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
            children: [
              InquiryDetail(
                inquiry: inquiry,
              ),
              InquiryGridActions(
                onTapPickup: onTapPickup,
                onTapStartChat: onTapStartChat,
                onTapClear: onTapClear,
                onTapCheckProfile: onTapCheckProfile,
                inquiry: inquiry,
                isLoading: isLoading,
                inquiryUuid: inquiryUuid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
