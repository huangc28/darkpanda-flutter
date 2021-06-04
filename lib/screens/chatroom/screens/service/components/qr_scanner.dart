import 'dart:io';

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/scan_qrcode.dart';
import 'package:darkpanda_flutter/screens/chatroom/components/slideup_controller.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/bloc/service_qrcode_bloc.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/service/screen_arguments/qrscanner_screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'service_qrcode.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({
    this.args,
  });

  final QrscannerScreenArguments args;
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

  String qrcodeUrl;

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

  _handleServiceQrCode() {
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
                  _animationController.reverse();
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
                      child: buildServiceQrCode(),
                      bottom: 60,
                    ),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: BlocListener<ServiceQrCodeBloc, ServiceQrCodeState>(
                listener: (context, state) {
                  if (state.status == AsyncLoadingStatus.done) {
                    setState(() {
                      qrcodeUrl = state.serviceQrCode.qrcodeUrl;
                    });
                  }
                },
                child: ServiceQrCode(
                  qrcodeUrl: qrcodeUrl,
                  controller: _slideUpController,
                  onTapClose: () {
                    _animationController.reverse();
                  },
                ),
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

  Widget buildServiceQrCode() {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          _handleServiceQrCode();
          BlocProvider.of<ServiceQrCodeBloc>(context)
              .add(LoadServiceQrCode(serviceUuid: widget.args.serviceUuid));
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
              'Service QR Code',
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
        // BlocProvider.of<ServiceQrCodeBloc>(context).add(ScanServiceQrCode(
        //     scanQrCode: ScanQrCode(
        //   qrCodeUuid: scanData.qrcode_uuid,
        //   qrCodeSecret: scanData.qrcode_secret,
        // )));
        print(scanData);
      });
    });
  }
}
