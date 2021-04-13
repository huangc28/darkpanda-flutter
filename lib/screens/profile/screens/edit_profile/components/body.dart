import 'dart:io';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DemoImage {
  final String image;
  final File imageFile;

  DemoImage({this.image, this.imageFile});
}

List demoImageList = [
  DemoImage(
    image: "assets/female_icon_active.png",
    imageFile: null,
  ),
  DemoImage(
    image: "",
    imageFile: null,
  ),
];

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            ProfilePicture(),
            InputTextLabel(label: "暱稱*"),
            SizedBox(height: 20),
            buildNicknameInput(),
            SizedBox(height: 24),
            InputTextLabel(label: "年齡"),
            SizedBox(height: 20),
            buildAgeInput(),
            SizedBox(height: 24),
            InputTextLabel(label: "身高"),
            SizedBox(height: 20),
            buildHeightInput(),
            SizedBox(height: 24),
            InputTextLabel(label: "體重"),
            SizedBox(height: 20),
            buildWeightInput(),
            SizedBox(height: 24),
            InputTextLabel(label: "身形"),
            Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: <Widget>[
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color.fromRGBO(190, 172, 255, 0.3),
                              ),
                              child: Text(
                                '火辣',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            InputTextLabel(label: "特色"),
            Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: <Widget>[
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color.fromRGBO(190, 172, 255, 0.3),
                              ),
                              child: Text(
                                '健談',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            InputTextLabel(label: "個性"),
            Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: <Widget>[
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Color.fromRGBO(190, 172, 255, 0.3),
                              ),
                              child: Text(
                                '外向',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            InputTextLabel(label: "簡介"),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.multiline,
              onChanged: (summary) {},
              maxLines: 4,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 8.0),
                filled: true,
                fillColor: Color.fromRGBO(255, 255, 255, 0.1),
              ),
            ),
            SizedBox(height: 24),
            InputTextLabel(label: "照片*（至少上傳兩張）"),
            buildAddImage(),
            SizedBox(height: 20),
            buildUpdateButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        DemoImage demoImage = DemoImage(
          image: null,
          imageFile: _image,
        );
        demoImageList.removeAt(demoImageList.length - 1);
        demoImageList.add(demoImage);
        demoImage = DemoImage(
          image: "",
          imageFile: null,
        );
        demoImageList.add(demoImage);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        DemoImage demoImage = DemoImage(
          image: null,
          imageFile: _image,
        );
        demoImageList.removeAt(demoImageList.length - 1);
        demoImageList.add(demoImage);
        demoImage = DemoImage(
          image: "",
          imageFile: null,
        );
        demoImageList.add(demoImage);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget buildNicknameInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildAgeInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildHeightInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildWeightInput() {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: inputDecoration(),
        ),
      ],
    );
  }

  Widget buildAddImage() {
    return Container(
      height: 190,
      padding: EdgeInsets.only(top: 25),
      child: ListView.builder(
        itemCount: demoImageList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // setState(() {
              //  index;
              // });
              // demoImageList.removeAt(2);
              if (index == demoImageList.length - 1) {
                _showPicker(context);
              }
            },
            child: demoImageList[index].image == ""
                ? AddImageButton()
                : demoImageList[index].image == null
                    ? ImageCardUpload(image: demoImageList[index].imageFile)
                    : ImageCard(image: demoImageList[index].image),
          );
        },
      ),
    );
  }

  Widget buildUpdateButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 44,
        child: DPTextButton(
          theme: DPTextButtonThemes.purple,
          onPressed: () {},
          text: '更新',
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getGalleryImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getCameraImage();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class InputTextLabel extends StatelessWidget {
  final String label;

  const InputTextLabel({
    Key key,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 7.0,
          width: 7.0,
          transform: new Matrix4.identity()..rotateZ(45 * 3.1415927 / 180),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
      ),
    );
  }
}

InputDecoration inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromRGBO(255, 255, 255, 0.1),
    labelStyle: TextStyle(color: Colors.white),
    // hintText: 'Enter Username',
    contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      borderRadius: BorderRadius.circular(25.7),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      borderRadius: BorderRadius.circular(25.7),
    ),
  );
}

class ImageCard extends StatefulWidget {
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;
  final String image;

  const ImageCard({
    Key key,
    this.operation,
    this.selectedIcon,
    this.unselectedIcon,
    this.isSelected,
    this.image,
  }) : super(key: key);

  @override
  _ImageCardState createState() => _ImageCardState(this.image);
}

class _ImageCardState extends State<ImageCard> {
  final String image;

  _ImageCardState(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Image(
            image: AssetImage(image),
          ),
        ],
      ),
    );
  }
}

class ImageCardUpload extends StatefulWidget {
  final File image;

  const ImageCardUpload({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  _ImageCardUploadState createState() => _ImageCardUploadState(this.image);
}

class _ImageCardUploadState extends State<ImageCardUpload> {
  final File image;

  _ImageCardUploadState(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Image.file(
            image,
          ),
        ],
      ),
    );
  }
}

class AddImageButton extends StatefulWidget {
  @override
  _AddImageButtonState createState() => _AddImageButtonState();
}

class _AddImageButtonState extends State<AddImageButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(255, 255, 255, 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '+',
            style: TextStyle(
              fontSize: 55,
              color: Colors.white,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
