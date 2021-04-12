part of 'service_settings_sheet.dart';

class AppointmentTimeField extends StatelessWidget {
  const AppointmentTimeField({
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
    return Container(
      child: Column(
        children: [
          Bullet(
            '見面時間',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: DPTextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    theme: DPTextFieldThemes.inquiryForm,
                    hintText: '年/月/日',
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  child: DPTextFormField(
                    controller: controller,
                    validator: validator,
                    focusNode: focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    theme: DPTextFieldThemes.inquiryForm,
                    hintText: '時間',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
