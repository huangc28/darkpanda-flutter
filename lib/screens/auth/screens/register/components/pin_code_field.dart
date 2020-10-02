import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeField extends StatelessWidget {
  const PinCodeField({
    this.errorController,
    this.onChanged,
    this.onCompleted,
  });

  static const PinCodeLength = 4;

  final StreamController<ErrorAnimationType> errorController;

  final ValueChanged<void> onChanged;

  final ValueChanged<void> onCompleted;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      errorAnimationController: errorController,
      appContext: context,
      length: PinCodeField.PinCodeLength,
      onChanged: onChanged,
      onCompleted: onCompleted,
      keyboardType: TextInputType.number,
    );
  }
}
