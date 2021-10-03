import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/util/size_config.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';

import '../../screen_arguments/args.dart';
import '../../components/step_bar_image.dart';

class ChooseGender extends StatefulWidget {
  ChooseGender({
    Key key,
    this.onPush,
  }) : super(
          key: key,
        );

  final Function(String, VerifyReferralCodeArguments) onPush;

  @override
  _ChooseGenderState createState() => _ChooseGenderState();
}

class _ChooseGenderState extends State<ChooseGender> {
  bool _femaleBtnActive = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        title: Text('註冊'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenHeight * 0.02, //16.0,
            vertical: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepBarImage(
                step: RegisterStep.StepOne,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  SizeConfig.screenWidth * 0.03,
                  SizeConfig.screenHeight * 0.08,
                  SizeConfig.screenWidth * 0.03,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    Text(
                      '你的性別',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Female button
                        InkWell(
                          onTap: () {
                            setState(() {
                              _femaleBtnActive = true;
                            });
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            child: _femaleBtnActive
                                ? SizedBox(
                                    width: SizeConfig.screenWidth * 0.4,
                                    child: Image.asset(
                                      'assets/female_icon_active.png',
                                    ),
                                  )
                                : SizedBox(
                                    width: SizeConfig.screenWidth * 0.4,
                                    child: Image.asset(
                                      'assets/female_icon_inactive.png',
                                    ),
                                  ),
                          ),
                        ),

                        // Male button
                        InkWell(
                          onTap: () {
                            setState(() {
                              _femaleBtnActive = false;
                            });
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: _femaleBtnActive
                              ? SizedBox(
                                  width: SizeConfig.screenWidth * 0.4,
                                  child: Image.asset(
                                    'assets/male_icon_inactive.png',
                                  ),
                                )
                              : SizedBox(
                                  width: SizeConfig.screenWidth * 0.4,
                                  child: Image.asset(
                                    'assets/male_icon_active.png',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Next step button
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: SizeConfig.screenHeight * 0.065,
                    child: DPTextButton(
                      theme: DPTextButtonThemes.purple,
                      onPressed: () {
                        /// if `_femaleBtnActive` is true, the user has chosen female, if not, the user has chosen male.
                        // var _gender =
                        //     _femaleBtnActive ? Gender.female : Gender.male;

                        var _gender = _femaleBtnActive ? 'female' : 'male';

                        widget.onPush(
                          '/register/verify-referral-code',
                          VerifyReferralCodeArguments(gender: _gender),
                        );
                      },
                      text: '下一步',
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.screenHeight * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
