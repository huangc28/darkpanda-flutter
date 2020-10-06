import 'package:flutter/material.dart';

// @TODOs:
//   - Make the modal square
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
          key: key,
          backgroundColor: Colors.black54,
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                width: 54,
                height: 54,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  static closeLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
