part of 'user_service_sheet.dart';

class ServiceNameField extends StatelessWidget {
  const ServiceNameField({
    Key key,
    this.controller,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> validator;
  final ValueChanged<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bullet(
          '服務名稱',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 70,
          child: DPTextFormField(
            controller: controller,
            validator: validator,
            onSaved: onSaved,
            textAlignVertical: TextAlignVertical.center,
            theme: DPTextFieldThemes.inquiryForm,
            hintText: '請輸入服務名稱',
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
      ],
    );
  }
}
