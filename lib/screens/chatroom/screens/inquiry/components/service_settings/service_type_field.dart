import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

class ServiceTypeField extends StatelessWidget {
  const ServiceTypeField({
    Key key,
    this.controller,
    this.validator,
    this.focusNode,
    this.onSaved,
    this.readOnly = false,
  }) : super(key: key);

  // Passed from outside to manipuate service type input.
  final TextEditingController controller;

  // Check validity of service type value.
  final ValueChanged<String> validator;

  final FocusNode focusNode;

  // Callback to invoke when save is pressed.
  final ValueChanged<String> onSaved;

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bullet(
          '期望服務 (10 字以內，非必填)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        DPTextFormField(
          readOnly: readOnly,
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          textAlignVertical: TextAlignVertical.center,
          theme: DPTextFieldThemes.inquiryForm,
          hintText: '請輸入期望服務',
          onSaved: onSaved,
        ),
      ],
    );
  }
}
