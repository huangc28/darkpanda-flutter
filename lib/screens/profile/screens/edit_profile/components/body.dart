import 'dart:io';
import 'dart:async';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/models/user_image.dart';

import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/update_profile_bloc.dart';
import 'package:darkpanda_flutter/screens/profile/screens/profile.dart';
import 'package:darkpanda_flutter/util/decimal_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class Body extends StatefulWidget {
  final UserProfile args;
  final List<UserImage> imageList;

  const Body({
    Key key,
    this.args,
    this.imageList,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File _image;
  final picker = ImagePicker();
  UpdateProfileBloc updateProfileBloc = UpdateProfileBloc();
  UserProfile userProfile;
  TextEditingController _nicknameTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  TextEditingController _heightTextController = TextEditingController();
  TextEditingController _weightTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  UserImage userImageAdd = UserImage(url: "");
  List<UserImage> removeImageList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UpdateProfileBloc>(context)
        .add(FetchProfileEdit(widget.args));

    widget.imageList.add(userImageAdd);
  }

  @override
  void dispose() {
    updateProfileBloc.close();
    _nicknameTextController.clear();
    _ageTextController.clear();
    _heightTextController.clear();
    _weightTextController.clear();
    _descriptionTextController.clear();

    super.dispose();
  }

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
            buildDescriptionInput(),
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
        UserImage demoImage = UserImage(
          url: null,
          fileName: _image,
        );
        widget.imageList.removeAt(demoImageList.length - 1);
        widget.imageList.add(demoImage);
        widget.imageList.add(userImageAdd);
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

        UserImage demoImage = UserImage(
          url: null,
          fileName: _image,
        );
        widget.imageList.removeAt(widget.imageList.length - 1);
        widget.imageList.add(demoImage);
        widget.imageList.add(userImageAdd);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget buildNicknameInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        _nicknameTextController.text = state.nickname;
        return Column(
          children: <Widget>[
            TextFormField(
              controller: new TextEditingController.fromValue(
                new TextEditingValue(
                  text: _nicknameTextController.text,
                  selection: new TextSelection.collapsed(
                      offset: _nicknameTextController.text.length),
                ),
              ),
              style: TextStyle(color: Colors.white),
              decoration: inputDecoration("請輸入您的暱稱"),
              onChanged: (username) {
                context
                    .read<UpdateProfileBloc>()
                    .add(NicknameChanged(username));
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAgeInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      buildWhen: (previous, current) => previous.age != current.age,
      builder: (context, state) {
        _ageTextController.text = state.age == null ? '' : state.age.toString();
        return Column(
          children: <Widget>[
            TextFormField(
              controller: new TextEditingController.fromValue(
                new TextEditingValue(
                  text: _ageTextController.text,
                  selection: new TextSelection.collapsed(
                      offset: _ageTextController.text.length),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (age) {
                context.read<UpdateProfileBloc>().add(
                      AgeChanged(int.parse(age)),
                    );
              },
              style: TextStyle(color: Colors.white),
              decoration: inputDecoration("請選擇您的年齡"),
            ),
          ],
        );
      },
    );
  }

  Widget buildHeightInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      builder: (context, state) {
        _heightTextController.text =
            state.height == null ? '' : state.height.toString();
        return Column(
          children: <Widget>[
            TextFormField(
              controller: new TextEditingController.fromValue(
                new TextEditingValue(
                  text: _heightTextController.text,
                  selection: new TextSelection.collapsed(
                      offset: _heightTextController.text.length == 0
                          ? _heightTextController.text.length
                          : _heightTextController.text.length - 2),
                ),
              ),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (height) {
                context
                    .read<UpdateProfileBloc>()
                    .add(HeightChanged(double.parse(height)));
              },
              style: TextStyle(color: Colors.white),
              decoration: inputDecoration("請輸入您的身高"),
            ),
          ],
        );
      },
    );
  }

  Widget buildWeightInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      builder: (context, state) {
        _weightTextController.text =
            state.weight == null ? '' : state.weight.toString();
        return Column(
          children: <Widget>[
            TextFormField(
              controller: new TextEditingController.fromValue(
                new TextEditingValue(
                  text: _weightTextController.text,
                  selection: new TextSelection.collapsed(
                      offset: _weightTextController.text.length == 0
                          ? _weightTextController.text.length
                          : _weightTextController.text.length - 2),
                ),
              ),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 3)],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (weight) {
                context
                    .read<UpdateProfileBloc>()
                    .add(WeightChanged(double.parse(weight)));
              },
              style: TextStyle(color: Colors.white),
              decoration: inputDecoration("請輸入您的體重"),
            ),
          ],
        );
      },
    );
  }

  Widget buildDescriptionInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      builder: (context, state) {
        _descriptionTextController.text = state.description;
        return TextFormField(
          controller: new TextEditingController.fromValue(
            new TextEditingValue(
              text: _descriptionTextController.text,
              selection: new TextSelection.collapsed(
                  offset: _descriptionTextController.text.length),
            ),
          ),
          onChanged: (description) {
            context
                .read<UpdateProfileBloc>()
                .add(DescriptionChanged(description));
          },
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "請輸入您的自我介紹",
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
        );
      },
    );
  }

  Widget buildAddImage() {
    return Container(
      height: 190,
      padding: EdgeInsets.only(top: 25),
      child: ListView.builder(
        itemCount: widget.imageList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (index == widget.imageList.length - 1) {
                _showPicker(context);
              }
            },
            child: widget.imageList[index].url == ""
                ? AddImageButton()
                : widget.imageList[index].url == null
                    ? imageCardFile(index)
                    : imageCard(index),
          );
        },
      ),
    );
  }

  Widget imageCardFile(index) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          Image.file(
            widget.imageList[index].fileName,
            height: 150,
          ),
          Positioned(
            top: 5,
            right: 16,
            child: GestureDetector(
              onTap: () {
                print('delete image from List');
                widget.imageList.removeAt(index);
                setState(() {
                  print('set new state of images');
                });
              },
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageCard(index) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          Image.network(
            widget.imageList[index].url,
            fit: BoxFit.cover,
            height: 150,
          ),
          Positioned(
            top: 5,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  removeImageList.add(widget.imageList[index]);
                  widget.imageList.removeAt(index);
                });
              },
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUpdateButton() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.username != current.username ||
          previous.age != current.age ||
          previous.height != current.height ||
          previous.weight != current.weight ||
          previous.description != current.description,
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 44,
            child: DPTextButton(
              theme: DPTextButtonThemes.purple,
              onPressed: () {
                BlocProvider.of<UpdateProfileBloc>(context).add(
                  UpdateUserProfile(widget.imageList, removeImageList),
                );
              },
              text: '更新',
            ),
          ),
        );
      },
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
      },
    );
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

InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    filled: true,
    fillColor: Color.fromRGBO(255, 255, 255, 0.1),
    labelStyle: TextStyle(color: Colors.white),
    hintText: hintText,
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
