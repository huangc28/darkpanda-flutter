part of '../../../../screens/inquiry/components/service_settings/service_settings_sheet.dart';

class ServiceDurationField extends StatelessWidget {
  const ServiceDurationField({
    Key key,
    this.controller,
    this.validator,
    this.onSaved,
    this.fontColor = Colors.black,
    this.readOnly,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> validator;
  final ValueChanged<String> onSaved;
  final Color fontColor;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Bullet(
            '服務時長(分鐘)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: fontColor,
            ),
          ),
          SizedBox(height: 12),
          DPTextFormField(
            readOnly: readOnly,
            hintText: '服務時長',
            onSaved: onSaved,
            controller: controller,
            theme: DPTextFieldThemes.inquiryForm,
            keyboardType: TextInputType.number,
            validator: validator,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ],
      ),
    );
  }
}
