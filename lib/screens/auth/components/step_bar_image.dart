import 'package:flutter/material.dart';

enum RegisterStep {
  StepOne,
  StepTwo,
  StepThree,
  StepFour,
}

Map<RegisterStep, String> _stepImageMap = {
  RegisterStep.StepOne: 'assets/register_step_one_banner.png',
  RegisterStep.StepTwo: 'assets/register_step_two_banner.png',
  RegisterStep.StepThree: 'assets/register_step_three_banner.png',
  RegisterStep.StepFour: 'assets/register_step_four_banner.png',
};

Map<RegisterStep, String> _stepValue = {
  RegisterStep.StepOne: '01/04',
  RegisterStep.StepTwo: '02/04',
  RegisterStep.StepThree: '03/04',
  RegisterStep.StepFour: '04/04',
};

class StepBarImage extends StatelessWidget {
  const StepBarImage({
    Key key,
    @required this.step,
  }) : super(key: key);

  final RegisterStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                _stepImageMap[step],
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Step indicator
        Text(
          _stepValue[step],
          style: TextStyle(
            fontSize: 15,
            color: Color.fromRGBO(106, 109, 137, 1),
          ),
        ),
      ],
    );
    ;
  }
}
