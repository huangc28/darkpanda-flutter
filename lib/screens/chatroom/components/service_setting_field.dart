part of 'service_settings_sheet.dart';

class ServiceSettingField extends StatelessWidget {
  const ServiceSettingField({
    @required this.builder,
    this.serviceLabel,
    this.onTap,
  }) : assert(builder != null);

  final Widget serviceLabel;
  final Function onTap;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        serviceLabel ?? Container(),
        SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: onTap,
                child: Container(
                  alignment: Alignment.center,
                  child: builder(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
