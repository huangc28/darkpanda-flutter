import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

import '../../../models/inquiry.dart';

part 'inquiry_grid_inquiry_detail.dart';

class InquiryGrid extends StatelessWidget {
  const InquiryGrid({
    Key key,
    @required this.onTapAvatar,
    @required this.onTapPickup,
    this.inquiry,
  }) : super(key: key);

  final Inquiry inquiry;
  final ValueChanged<String> onTapAvatar;
  final ValueChanged<String> onTapPickup;

// @Issue: https://stackoverflow.com/questions/58812778/a-borderradius-can-only-be-given-for-uniform-borders
  Widget _buildActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(106, 109, 137, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        margin: const EdgeInsetsDirectional.only(
          start: 0.5,
          end: 0.5,
          top: 1,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(6.0),
            topRight: const Radius.circular(6.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Hide button
            Expanded(
              child: DPTextButton(
                theme: DPTextButtonThemes.grey,
                onPressed: () {
                  print('DEBUG trigger hide');
                },
                text: '隱藏',
              ),
            ),

            SizedBox(
              width: 11,
            ),

            // Check profile button
            Expanded(
              child: SizedBox(
                height: 44,
                child: DPTextButton(
                  theme: DPTextButtonThemes.grey,
                  onPressed: () {
                    print('DEBUG trigger hide');
                  },
                  text: '檔案',
                ),
              ),
            ),

            SizedBox(
              width: 11,
            ),

            // Chat now button
            Expanded(
              child: DPTextButton(
                theme: DPTextButtonThemes.lightGrey,
                onPressed: () {
                  print('DEBUG trigger hide');
                },
                text: '聊聊',
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          _buildActionBar(),
        ],
      ),
    );
  }
}
