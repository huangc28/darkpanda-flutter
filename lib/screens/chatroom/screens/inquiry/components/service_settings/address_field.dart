part of './service_settings_sheet.dart';

class AddressField extends StatelessWidget {
  const AddressField({
    Key key,
    this.controller,
    this.validator,
    this.focusNode,
    this.fontColor = Colors.black,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> validator;
  final FocusNode focusNode;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bullet(
          '地址',
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
          hintText: '請輸入地址',
        ),
      ],
    );
  }
}
