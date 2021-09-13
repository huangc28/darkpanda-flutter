import 'package:darkpanda_flutter/components/user_avatar.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/service_types.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';
import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({
    this.serviceSettings,
    this.authUser,
    this.serviceDetailStatus,
    Key key,
  }) : super(key: key);

  final ServiceSettings serviceSettings;
  final AuthUser authUser;
  final AsyncLoadingStatus serviceDetailStatus;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (widget.serviceDetailStatus == AsyncLoadingStatus.done)
              Container(
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(31, 30, 56, 1),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: UserAvatar(
                                  widget.authUser.avatarUrl != null
                                      ? widget.authUser.avatarUrl
                                      : ''),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildUserInfo(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildServiceDetail(),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
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
                    widget.authUser.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetail() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(17, 16, 41, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              Container(
                height: 7.0,
                width: 7.0,
                transform: new Matrix4.identity()
                  ..rotateZ(45 * 3.1415927 / 180),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(254, 226, 136, 1),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text(
                '交易明細',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildAddressTimeCardInfo(),
          SizedBox(height: 20),
          _buildDpCardInfo(),
        ],
      ),
    );
  }

  Widget _buildAddressTimeCardInfo() {
    final durationSplit = widget.serviceSettings.duration.toString().split(':');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(255, 255, 255, 0.1),
        border: Border.all(
          style: BorderStyle.solid,
          width: 0.5,
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildEachText(
              'place.png',
              '類型',
              widget.serviceSettings.serviceType != null
                  ? widget.serviceSettings.serviceType
                  : ''),
          SizedBox(height: 15),
          _buildEachText(
              'clock.png',
              '時間',
              widget.serviceSettings.serviceDate != null
                  ? '${DateFormat("MM/dd/yy, hh: mm a").format(widget.serviceSettings.serviceDate)}'
                  : ''),
          SizedBox(height: 15),
          if (durationSplit.length > 0)
            _buildEachText(
              'countDown.png',
              '時長',
              widget.serviceSettings.duration >
                          Duration(hours: 0, minutes: 1) &&
                      widget.serviceSettings.duration <=
                          Duration(hours: 0, minutes: 59)
                  ? '${durationSplit[1]} 分'
                  : '${durationSplit.first} 小時 ${durationSplit[1]} 分',
            ),
        ],
      ),
    );
  }

  Widget _buildDpCardInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(255, 255, 255, 0.1),
        border: Border.all(
          style: BorderStyle.solid,
          width: 0.5,
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEachText('pie.png', '预算', '${widget.serviceSettings.budget}'),
        ],
      ),
    );
  }

  Widget _buildEachText(String iconName, String title, String value,
      {Color titleColor, double titleSize, double valueSize}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            child: Image.asset(
              'lib/screens/service_list/assets/$iconName',
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${title}:',
            style: TextStyle(
              color: titleColor != null
                  ? titleColor
                  : Color.fromRGBO(106, 109, 137, 1),
              fontSize: titleSize != null ? titleSize : 13,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: value == ServiceTypes.sex.name
                ? Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  )
                : Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: valueSize != null ? valueSize : 15,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
