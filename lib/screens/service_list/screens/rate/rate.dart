import 'package:darkpanda_flutter/screens/service_list/screens/rate/components/complete_rate.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class Rate extends StatefulWidget {
  const Rate({
    Key key,
  }) : super(key: key);

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
        title: Text('評價'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          ),
          SizedBox(width: 20),
        ],
        iconTheme: IconThemeData(
          color: Color.fromRGBO(106, 109, 137, 1), //change your color here
        ),
      ),
      body: complete == false
          ? Body(
              formKey: _formKey,
              onPressComplete: () {
                setState(() {
                  complete = true;
                });
              },
            )
          : CompleteRate(),
    );
  }
}
