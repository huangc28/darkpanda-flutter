import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/util/convertZeroDecimalToInt.dart';
import 'package:flutter/material.dart';

class UserTraits extends StatefulWidget {
  const UserTraits({
    Key key,
    this.userTrait,
  }) : super(key: key);

  final UserTrait userTrait;

  @override
  _UserTraitsState createState() => _UserTraitsState();
}

class _UserTraitsState extends State<UserTraits> {
  @override
  Widget build(BuildContext context) {
    String label = '歲';
    dynamic value = '';

    if (widget.userTrait.type == 'age') {
      label = '歲';
      value = widget.userTrait.value;
    } else if (widget.userTrait.type == 'height') {
      label = 'CM';
      value = widget.userTrait.value;
    } else {
      label = 'KG';
      value = widget.userTrait.value;
    }

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromRGBO(190, 172, 255, 0.3),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                convertZeroDecimalToInt(value) + label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
