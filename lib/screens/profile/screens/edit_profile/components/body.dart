import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darkpanda_flutter/components/camera_screen.dart';
import 'package:darkpanda_flutter/util/validator.dart';

import 'package:image/image.dart' as img;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/models/user_image.dart';
import 'package:darkpanda_flutter/components/unfocus_primary.dart';

import 'package:darkpanda_flutter/models/user_profile.dart';
import 'package:darkpanda_flutter/screens/profile/bloc/update_profile_bloc.dart';
import 'package:darkpanda_flutter/util/size_config.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    this.args,
    this.imageList,
    this.isLoading,
  }) : super(key: key);

  final UserProfile args;
  final List<UserImage> imageList;
  final bool isLoading;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File _image;
  final picker = ImagePicker();
  UpdateProfileBloc updateProfileBloc = UpdateProfileBloc();
  TextEditingController _nicknameTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  TextEditingController _heightTextController = TextEditingController();
  TextEditingController _weightTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  UserImage userImageAdd;
  List<UserImage> removeImageList = [];

  File _avatarImageFile;
  List<UserImage> images = [];

  UserProfile _userProfile = UserProfile();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    userImageAdd = UserImage(url: ""); // is add button

    BlocProvider.of<UpdateProfileBloc>(context)
        .add(FetchProfileEdit(widget.args));

    widget.imageList.add(userImageAdd);
    images = widget.imageList;

    super.initState();
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

  void _showPicker() {
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
                    // getCameraImage();
                    Navigator.of(context).pop();
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          onTakePhoto: (xFile) {
                            getCameraImage(xFile);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPickerAvatar() {
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
                      getGalleryImageAvatar();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          onTakePhoto: (xFile) {
                            getCameraImageAvatar(xFile);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusPrimary(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                _avatarImage(),
                InputTextLabel(label: "暱稱*"),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                buildNicknameInput(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.028, //24
                ),
                InputTextLabel(label: "年齡"),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                buildAgeInput(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.028, //24
                ),
                InputTextLabel(label: "身高"),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                buildHeightInput(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.028, //24
                ),
                InputTextLabel(label: "體重"),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                buildWeightInput(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.028, //24
                ),
                InputTextLabel(label: "簡介"),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                buildDescriptionInput(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.028, //24
                ),
                InputTextLabel(label: "照片*（至少上傳兩張）"),
                buildAddImage(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
                buildUpdateButton(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.022, //20
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getCameraImage(XFile image) async {
    try {
      final img.Image capturedImage =
          img.decodeImage(await File(image.path).readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage);

      await File(image.path).writeAsBytes(img.encodeJpg(orientedImage));

      setState(() {
        if (image != null) {
          _image = File(image.path);
          UserImage demoImage = UserImage(
            url: null,
            fileName: _image,
          );

          if (images.length > 0) {
            images.removeAt(images.length - 1);
          }

          images.add(demoImage);
          images.add(userImageAdd);
        } else {
          print('No image selected.');
        }
      });
    } catch (error) {
      print('error taking picture ${error.toString()}');
    }
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        UserImage demoImage = UserImage(
          url: null,
          fileName: _image,
        );
        if (images.length > 0) {
          images.removeAt(images.length - 1);
        }

        images.add(demoImage);
        images.add(userImageAdd);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getGalleryImageAvatar() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );

    setState(() {
      if (pickedFile != null) {
        _avatarImageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCameraImageAvatar(XFile pickedFile) async {
    final img.Image capturedImage =
        img.decodeImage(await File(pickedFile.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage);

    await File(pickedFile.path).writeAsBytes(img.encodeJpg(orientedImage));

    setState(() {
      if (pickedFile != null) {
        _avatarImageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _avatarImage() {
    return Container(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: _avatarImageFile != null
            ? FileImage(_avatarImageFile)
            : widget.args.avatarUrl != ""
                ? NetworkImage(widget.args.avatarUrl)
                : _avatarImageFile == null
                    ? AssetImage('assets/default_avatar.png')
                    : FileImage(_avatarImageFile),
        child: Align(
          alignment: Alignment.topRight,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[400],
            child: IconButton(
              onPressed: () {
                print('edit');
                _showPickerAvatar();
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.edit,
                color: Colors.black,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNicknameInput() {
    return BlocBuilder<UpdateProfileBloc, UpdateProfileState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        _nicknameTextController.text = state.username;
        return Column(
          children: <Widget>[
            TextFormField(
              readOnly: true,
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
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        _ageTextController.text = state.age == null ? '' : state.age.toString();
      },
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _ageTextController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Colors.white),
            decoration: inputDecoration("請選擇您的年齡"),
          ),
        ],
      ),
    );
  }

  Widget buildHeightInput() {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        _heightTextController.text =
            state.height == null ? '' : state.height.toString();
      },
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _heightTextController,
            inputFormatters: [
              ValidatorInputFormatter(
                editingValidator: DecimalNumberEditingRegexValidator(),
              ),
            ],
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: inputDecoration("請輸入您的身高"),
          ),
        ],
      ),
    );
  }

  Widget buildWeightInput() {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        _weightTextController.text =
            state.weight == null ? '' : state.weight.toString();
      },
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _weightTextController,
            inputFormatters: [
              ValidatorInputFormatter(
                editingValidator: DecimalNumberEditingRegexValidator(),
              ),
            ],
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: inputDecoration("請輸入您的體重"),
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionInput() {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        _descriptionTextController.text = state.description;
      },
      child: TextFormField(
        controller: _descriptionTextController,
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
      ),
    );
  }

  Widget buildAddImage() {
    print("ImageList length: " + images.length.toString());
    return Container(
      height: 190,
      padding: EdgeInsets.only(top: 25),
      child: ListView.builder(
        itemCount: images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return images[index].url == ""
              ? _addImageButton()
              : images[index].url == null
                  ? imageCardFile(index)
                  : imageCard(index);
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
            images[index].fileName,
            height: 150,
            width: 115,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 5,
            right: 16,
            child: GestureDetector(
              onTap: () {
                print('delete image from List');

                setState(() {
                  images.removeAt(index);
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
            fit: BoxFit.fill,
            height: 150,
            width: 115,
          ),
          Positioned(
            top: 5,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  removeImageList.add(images[index]);
                  images.removeAt(index);
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
              disabled: widget.isLoading,
              loading: widget.isLoading,
              theme: DPTextButtonThemes.purple,
              onPressed: () {
                _userProfile = _userProfile.copyWith(
                  age: int.tryParse(_ageTextController.text),
                  height: double.tryParse(_heightTextController.text),
                  weight: double.tryParse(_weightTextController.text),
                  description: _descriptionTextController.text,
                );

                BlocProvider.of<UpdateProfileBloc>(context).add(
                  UpdateUserProfile(
                    widget.imageList,
                    removeImageList,
                    _avatarImageFile,
                    _userProfile,
                  ),
                );
              },
              text: '更新',
            ),
          ),
        );
      },
    );
  }

  Widget _addImageButton() {
    return GestureDetector(
      onTap: () {
        _showPicker();
      },
      child: Container(
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
      ),
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

class DecimalNumberEditingRegexValidator extends RegexValidator {
  DecimalNumberEditingRegexValidator()
      : super(regexSource: "^\$|^(0|([1-9][0-9]{0,2}))(\\.[0-9]{0,2})?\$");
}
