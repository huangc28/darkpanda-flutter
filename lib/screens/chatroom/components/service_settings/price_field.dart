part of 'service_settings_sheet.dart';

class PriceField extends StatelessWidget {
  const PriceField({
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
          '價格(DP幣)',
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
            hintText: '請輸入價格',
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
