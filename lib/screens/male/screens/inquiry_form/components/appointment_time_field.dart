part of 'body.dart';

class AppointmentTimeField extends StatelessWidget {
  const AppointmentTimeField({
    Key key,
    this.dateController,
    this.timeController,
    this.onSelectDate,
    this.onSelectTime,
    this.validator,
    this.focusNode,
    this.dateValue,
    this.timeValue,
  }) : super(key: key);

  final TextEditingController dateController;
  final TextEditingController timeController;
  final Function(DateTime) onSelectDate;
  final Function(TimeOfDay) onSelectTime;
  final ValueChanged<String> validator;
  final FocusNode focusNode;
  final DateTime dateValue;
  final TimeOfDay timeValue;

  _handleTapDate(BuildContext context) async {
    final selectedDate = dateValue;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime.now().add(
        Duration(days: 60),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (pickedDate != null) {
      onSelectDate(pickedDate);
    }
  }

  _handleTapTime(BuildContext context) async {
    final selectedTime = timeValue;
    final pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      onSelectTime(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              /// Show native datePicker when click on the date field.
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleTapDate(context),
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      child: DPTextFormField(
                        controller: dateController,
                        textAlignVertical: TextAlignVertical.center,
                        theme: DPTextFieldThemes.inquiryForm,
                        hintText: '年/月/日',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleTapTime(context),
                  child: Container(
                    color: Colors.transparent,
                    child: IgnorePointer(
                      child: DPTextFormField(
                        controller: timeController,
                        validator: validator,
                        focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        theme: DPTextFieldThemes.inquiryForm,
                        hintText: '時間',
                      ),
                    ),
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
