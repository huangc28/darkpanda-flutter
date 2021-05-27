import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrCode extends StatefulWidget {
  const MyQrCode({
    this.controller,
    @required this.onTapClose,
  });

  final SlideUpController controller;
  final VoidCallback onTapClose;

  @override
  _MyQrCodeState createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SlideUpProvider(),
      child: Consumer<SlideUpProvider>(
        builder: (context, provider, child) {
          widget.controller?.providerContext = context;
          return provider.isShow
              ? Stack(
                  children: <Widget>[
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    Positioned(
                      child: buildCancelButton(),
                      top: 20,
                      left: 20,
                    ),
                    Positioned(
                      child: buildQrImage(),
                      bottom: 0.0,
                      right: 0.0,
                      left: 0.0,
                      top: 0.0,
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  Widget buildQrImage() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(106, 109, 137, 1),
              ),
            ),
            child: QrImage(
              data: "123",
              size: 200,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCancelButton() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          widget.onTapClose();
        },
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
