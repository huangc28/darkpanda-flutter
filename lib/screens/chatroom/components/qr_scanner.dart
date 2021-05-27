import 'dart:io';

import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'my_qrcode.dart';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  final SlideUpController _slideUpController = SlideUpController();

  /// Animations controllers.
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize slideup panel animation.
    _initSlideUpAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  // @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  _initSlideUpAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.decelerate,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          // Start animation at begin
          _slideUpController.toggle();
        } else if (status == AnimationStatus.dismissed) {
          // To hide widget, we need complete animation first
          _slideUpController.toggle();
        }
      });

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));
  }

  _handleMyQrCode() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            FadeTransition(
              opacity: _fadeAnimation,
              child: InkWell(
                onTap: () {
                  if (_animationController.isDismissed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    buildQrView(),
                    Positioned(
                      child: buildCancelButton(),
                      top: 30,
                      left: 30,
                    ),
                    Positioned(
                      child: buildMyQrCode(),
                      bottom: 60,
                    ),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: MyQrCode(
                controller: _slideUpController,
                onTapClose: () {
                  _animationController.reverse();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCancelButton() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMyQrCode() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          _handleMyQrCode();
        },
        child: Row(
          children: [
            Icon(
              Icons.qr_code_outlined,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'My QR Code',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQrView() {
    return Container(
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).colorScheme.secondary,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        print(scanData);
      });
    });
  }
}
