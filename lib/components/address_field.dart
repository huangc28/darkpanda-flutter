import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

class AddressField extends StatelessWidget {
  const AddressField({
    Key key,
    this.controller,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> validator;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bullet(
          '地址',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        DPTextFormField(
          readOnly: true,
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          theme: DPTextFieldThemes.inquiryForm,
          hintText: '請輸入地址',
        ),
      ],
    );
  }
}
