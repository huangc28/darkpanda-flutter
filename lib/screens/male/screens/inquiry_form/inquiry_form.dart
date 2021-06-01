import 'package:flutter/material.dart';

import 'components/body.dart';

class InquiryForm extends StatefulWidget {
  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("編輯需求"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      ),
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      body: Body(),
    );
  }
}
