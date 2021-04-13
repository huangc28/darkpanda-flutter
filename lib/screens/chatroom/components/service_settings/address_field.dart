part of 'service_settings_sheet.dart';

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
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 44,
          child: DPTextFormField(
            readOnly: true,
            focusNode: focusNode,
            controller: controller,
            validator: validator,
            textAlignVertical: TextAlignVertical.center,
            theme: DPTextFieldThemes.inquiryForm,
            hintText: '請輸入地址',
          ),
        ),
      ],
    );
  }
}
