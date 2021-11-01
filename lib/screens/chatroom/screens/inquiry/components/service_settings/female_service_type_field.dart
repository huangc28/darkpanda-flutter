import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

class FemaleServiceTypeField extends StatelessWidget {
  const FemaleServiceTypeField({
    Key key,
    this.controller,
    this.validator,
    this.focusNode,
    this.onSaved,
    this.fontColor = Colors.black,
  }) : super(key: key);

  // Passed from outside to manipuate service type input.
  final TextEditingController controller;

  // Check validity of service type value.
  final ValueChanged<String> validator;

  final FocusNode focusNode;

  // Callback to invoke when save is pressed.
  final ValueChanged<String> onSaved;

  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bullet(
          '服務',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: fontColor,
          ),
        ),
        SizedBox(height: 10),
        DPTextFormField(
          readOnly: true,
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          textAlignVertical: TextAlignVertical.center,
          theme: DPTextFieldThemes.inquiryForm,
          hintText: '請輸入服務',
          onSaved: onSaved,
        ),
      ],
    );
  }
}
