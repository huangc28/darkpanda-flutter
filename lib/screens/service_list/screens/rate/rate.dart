import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/screens/service_list/screens/rate/components/complete_rate.dart';

import 'components/body.dart';
import '../../models/historical_service.dart';

class Rate extends StatefulWidget {
  const Rate({
    Key key,
    this.historicalService,
  }) : super(key: key);

  final HistoricalService historicalService;

  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> with SingleTickerProviderStateMixin {
  bool complete = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 16, 41, 1),
          title: Text('評價'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            complete == false
                ? new IconButton(
                    icon: new Icon(Icons.close),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () => Navigator.of(context).pop(null),
                  )
                : Container(),
            SizedBox(width: 20),
          ],
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1), //change your color here
          ),
        ),
        body: Body(
          formKey: _formKey,
          historicalService: widget.historicalService,
          // onPressComplete: () {
          //   setState(() {
          //     complete = true;
          //   });
          // },
        ));
  }
}
