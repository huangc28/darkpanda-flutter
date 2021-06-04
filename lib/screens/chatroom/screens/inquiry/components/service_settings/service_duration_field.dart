part of '../../../../screens/inquiry/components/service_settings/service_settings_sheet.dart';

class ServiceDurationField extends StatelessWidget {
  const ServiceDurationField({
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
    return Container(
      height: 107,
      child: Column(
        children: [
          Bullet(
            '服務時長(分鐘)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          DPTextFormField(
            hintText: '服務時長',
            onSaved: onSaved,
            controller: controller,
            theme: DPTextFieldThemes.inquiryForm,
            keyboardType: TextInputType.number,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
