import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

import '../../../models/inquiry.dart';

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

  Widget _buildInquiryInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Inquiry details.
          Container(
            padding: EdgeInsets.only(
              left: 31,
              right: 25,
              top: 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Inquirer avatar.
                SizedBox(
                  height: 64,
                  width: 64,
                  child: CircleAvatar(
                      // backgroundImage: NetworkImage(
                      //   'https://www.fillmurray.com/640/360',
                      // ),
                      ),
                ),

                SizedBox(
                  height: 12,
                ),

                // Inquirer name
                Text(
                  'Brat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bullet(
                '預算: ${inquiry.budget} DP',
                style: TextStyle(
                  height: 1.3,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Bullet(
                '項目: ${inquiry.serviceType}',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.3,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Bullet(
                '時間: 12.18 at 00:20 AM',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.3,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Bullet(
                '時長: 1 小時',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.3,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
    print('DEBUG iq ~ ${inquiry.appointmentTime}');

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
          _buildInquiryInfo(),
          _buildActionBar(),
        ],
      ),
    );
  }
}
