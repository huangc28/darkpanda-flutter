import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceQrCode extends StatefulWidget {
  const ServiceQrCode({
    this.qrcodeUrl,
    this.controller,
    @required this.onTapClose,
  });

  final String qrcodeUrl;
  final SlideUpController controller;
  final VoidCallback onTapClose;

  @override
  _ServiceQrCodeState createState() => _ServiceQrCodeState();
}

class _ServiceQrCodeState extends State<ServiceQrCode> {
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
                      child: _buildCancelButton(),
                      top: 20,
                      left: 20,
                    ),
                    Positioned(
                      child: _buildQrImage(),
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

  Widget _buildQrImage() {
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
            child: widget.qrcodeUrl == null
                ? SizedBox.shrink()
                : Image(
                    image: NetworkImage(widget.qrcodeUrl),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
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
