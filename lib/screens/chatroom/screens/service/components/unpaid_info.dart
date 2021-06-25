part of '../service_chatroom.dart';

class UnpaidInfo extends StatelessWidget {
  const UnpaidInfo({
    Key key,
    this.inquirerProfile,
    this.serviceDetails,
    @required this.onGoToPayment,
  }) : super(key: key);

  final UserProfile inquirerProfile;
  final ServiceDetails serviceDetails;
  final VoidCallback onGoToPayment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(31, 30, 56, 1),
      child: Column(
        children: <Widget>[
          _totalDpInfo(),
          SizedBox(height: 10),
          _tradeInfo(),
        ],
      ),
    );
  }

  Widget _totalDpInfo() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 25, right: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Image.asset(
              'lib/screens/chatroom/assets/coin.png',
              width: 38,
              height: 38,
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  '总金额：',
                  style: TextStyle(
                    color: Color.fromRGBO(106, 109, 137, 1),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    serviceDetails.matchingFee.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'DP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _tradeInfo() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          style: BorderStyle.solid,
          width: 0.5,
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: UserAvatar(inquirerProfile.avatarUrl != null
                ? inquirerProfile.avatarUrl
                : ''),
            width: 38,
            height: 38,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '與${inquirerProfile.username}的交易',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '您還有 9 分鐘可以付款',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(106, 109, 137, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent, // background
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
                side: BorderSide(
                  color: Color.fromRGBO(106, 109, 137, 1),
                ),
              ),
            ),
            onPressed: onGoToPayment,
            child: Text(
              '前往付款',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
