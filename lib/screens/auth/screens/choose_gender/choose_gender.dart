import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/dp_button.dart';

import '../../components/step_bar_image.dart';

class ChooseGender extends StatefulWidget {
  ChooseGender({
    Key key,
    this.onPush,
  }) : super(key: key);

  final Function onPush;

  @override
  _ChooseGenderState createState() => _ChooseGenderState();
}

class _ChooseGenderState extends State<ChooseGender> {
  bool _femaleBtnActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepBarImage(
                step: RegisterStep.StepOne,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 46, 30, 0),
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
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Female button
                        InkWell(
                          onTap: () {
                            setState(() {
                              _femaleBtnActive = true;
                            });
                          },
                          child: Container(
                            child: _femaleBtnActive
                                ? Image.asset(
                                    'assets/female_icon_active.png',
                                  )
                                : Image.asset(
                                    'assets/female_icon_inactive.png',
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
                          child: Container(
                            child: _femaleBtnActive
                                ? Image.asset(
                                    'assets/male_icon_inactive.png',
                                  )
                                : Image.asset(
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
                  child: DPTextButton(
                    theme: DPTextButtonThemes.purple,
                    onPressed: () {
                      widget.onPush('/register/verify-referral-code');
                    },
                    text: '下一步',
                  ),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
