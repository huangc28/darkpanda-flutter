part of 'inquiry_grid.dart';

class InquiryDetail extends StatelessWidget {
  const InquiryDetail({
    this.inquiry,
  });

  final Inquiry inquiry;

  Widget _buildAppointmentTimeText() {
    final format = DateFormat.jm();
    final timeWithJM = format.format(inquiry.appointmentTime);

    return Bullet(
      // '時間: 12.18 at 00:20 AM',
      '時間: ${inquiry.appointmentTime.month}/${inquiry.appointmentTime.day} at ${timeWithJM}',
      style: TextStyle(
        color: Colors.white,
        height: 1.3,
        fontSize: 13,
      ),
    );
  }

  Widget _buildDurationText() {
    final durationSplit = inquiry.duration.toString().split(':');
    return Bullet(
      '時長: ${durationSplit.first} 小時 ${durationSplit[1]} 分',
      style: TextStyle(
        color: Colors.white,
        height: 1.3,
        fontSize: 13,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inquiry details.
        Container(
          width: SizeConfig.screenWidth * 0.35, //150,
          padding: EdgeInsets.only(
            left: SizeConfig.screenWidth * 0.07, //31,
            right: SizeConfig.screenWidth * 0.06, //25,
            bottom: SizeConfig.screenHeight * 0.014, //12,
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
                height: SizeConfig.screenHeight * 0.01, //10
              ),

              // Inquirer name
              Text(
                inquiry.inquirer.username,
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

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Bullet(
              '預算: ${inquiry.budget} DP',
              style: TextStyle(
                height: 1.3,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.01, //6
            ),
            Bullet(
              '項目: ${inquiry.serviceType}',
              style: TextStyle(
                color: Colors.white,
                height: 1.3,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.01, //6
            ),
            _buildAppointmentTimeText(),
            SizedBox(
              height: SizeConfig.screenHeight * 0.01, //6
            ),
            _buildDurationText(),
          ],
        ),
      ],
    );
  }
}
