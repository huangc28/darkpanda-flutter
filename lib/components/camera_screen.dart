import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:darkpanda_flutter/util/size_config.dart';

typedef TakePhotoCallback = void Function(File file);

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key key,
    this.onTakePhoto,
  }) : super(key: key);

  // final TakePhotoCallback onTakePhoto;
  final ValueChanged<XFile> onTakePhoto;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController _controller;

  List<CameraDescription> cameras = [];
  CameraDescription camera;

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    _initCameras();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initCameras() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      _controller = new CameraController(
        cameras[0],
        ResolutionPreset.high,
        // imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller.initialize();
    } on CameraException catch (err) {
      print(err);
    }

    if (!mounted) return;

    setState(() {});
  }

  Future<XFile> takePicture() async {
    final CameraController cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      print('A capture is already pending, do nothing');
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  void toggleCameraLens() async {
    print('reverse camera');
    // get current lens direction (front / rear)
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;

    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _controller = CameraController(newDescription, ResolutionPreset.max,
          enableAudio: true);

      try {
        await _controller.initialize();
        // to notify the widgets that camera has been initialized and now camera preview can be done
        setState(() {});
      } catch (e) {
        print(e);
      }
    } else {
      print('Asked camera not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(
            child: _cameraPreviewWidget(),
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (_controller == null || !_controller.value.isInitialized) {
      return Container(
        width: width,
        height: height - 110,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Stack(
      children: [
        Container(
          width: width,
          height: height - 110, // minus header and footer height
          child: CameraPreview(_controller),
        ),
        Positioned(
          child: buildCancelButton(),
          top: 30,
          left: 30,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(top: 35),
            color: Colors.black.withOpacity(0.6),
            height: 160,
            width: width,
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Image.asset(
                            'assets/photoBtn.png',
                            width: SizeConfig.screenWidth * 0.6, //80,
                            height: SizeConfig.screenHeight * 0.12, //80,
                          ),
                          onTap: () async {
                            print('take picture');
                            XFile file = await takePicture();
                            print(file);
                            widget.onTakePhoto(file);
                          },
                        ),
                      ],
                    ),
                    Positioned(
                      right: SizeConfig.screenWidth * 0.15, //20,
                      top: SizeConfig.screenHeight * 0.04, //25,
                      child: GestureDetector(
                        child: Image.asset(
                          'assets/icon20X20Switch.png',
                          width: 30,
                          height: 30,
                        ),
                        onTap: toggleCameraLens,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
              Icons.close,
              color: Color.fromRGBO(106, 109, 137, 1),
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
