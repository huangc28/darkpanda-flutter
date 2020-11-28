import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

import '../../../models/service_settings.dart';

part 'service_setting_field.dart';

// TODOs
//   - Add close button - [ok]
//   - Service type
//   - Add price field - [ok]
//   - Meet up date - [ok]
//   - Meet up time - [ok]
//   - Service duration - [ok]
//   - Location
//   - Time picker and Date picker fields have the same style - [ok]
//   - Save button - [ok]
//   - Cancel button - [ok]
//   - Replace the service settings with default values
//   - Add service type field
// @reference: https://medium.com/flutterdevs/date-and-time-picker-in-flutter-72141e7531c
// @reference: https://stackoverflow.com/questions/51908187/how-to-make-a-full-screen-dialog-in-flutter
class ServiceSettingsSheet extends StatefulWidget {
  const ServiceSettingsSheet({
    this.serviceSettings,
  });

  final ServiceSettings serviceSettings;

  @override
  _ServiceSettingsSheetState createState() => _ServiceSettingsSheetState();
}

class _ServiceSettingsSheetState extends State<ServiceSettingsSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ServiceSettings _serviceSetting = ServiceSettings(
    serviceDate: DateTime.now(),
    serviceTime: TimeOfDay(hour: 00, minute: 00),
    duration: Duration(hours: 0, minutes: 30),
  );

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    _initDefaultServiceSettings();

    _dateController.text = DateFormat.yMd().format(_serviceSetting.serviceDate);
    _timeController.text = formatDate(
      DateTime(
        _serviceSetting.serviceDate.year,
        _serviceSetting.serviceDate.month,
        _serviceSetting.serviceDate.day,
        _serviceSetting.serviceDate.hour,
        _serviceSetting.serviceDate.minute,
        0,
      ),
      [hh, ':', nn, " ", am],
    ).toString();
    _durationController.text = _formatDuration(_serviceSetting.duration);

    _priceController.text =
        _serviceSetting.price != null ? '${_serviceSetting.price}' : null;

    _serviceSetting.serviceType = _serviceSetting.serviceType;

    super.initState();
  }

  _initDefaultServiceSettings() {
    if (widget.serviceSettings == null) return;

    _serviceSetting = widget.serviceSettings;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}";
  }

  Widget _headingRow(BuildContext context) {
    return Row(
      children: [
        Text(
          'Service Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Spacer(),
        GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _headingRow(context),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildPriceField(),
                      SizedBox(
                        height: 25.0,
                      ),
                      _buildServiceDatePicker(),
                      SizedBox(
                        height: 25.0,
                      ),
                      _buildServiceTimePicker(),
                      SizedBox(
                        height: 25.0,
                      ),
                      _buildDurationPicker(),
                      ButtonBar(
                        children: [
                          _buildSaveButton(),
                          _buildCancelButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() => OutlineButton(
        child: Text(
          'Save',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }

          _formKey.currentState.save();

          Navigator.of(context).pop(_serviceSetting);
        },
      );

  Widget _buildCancelButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red[300],
        ),
        child: Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

  Widget _buildDurationPicker() {
    return ServiceSettingField(
      serviceLabel: Text('Select a service duration'),
      builder: (BuildContext context) => TextFormField(
        validator: (String v) {
          if (_serviceSetting.duration == null ||
              _serviceSetting.duration.inSeconds == 0) {
            return 'service duration can\'t be zero';
          }

          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        enabled: false,
        style: TextStyle(fontSize: 26),
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        controller: _durationController,
      ),
      onTap: () async {
        Duration pickedDuration = await showDurationPicker(
          context: context,
          initialTime: _serviceSetting.duration,
        );

        if (pickedDuration != null) {
          _serviceSetting.duration = pickedDuration;
          _durationController.text = _formatDuration(_serviceSetting.duration);
        }
      },
    );
  }

  Widget _buildServiceTimePicker() {
    return ServiceSettingField(
      serviceLabel: Text('Pick a time for this service'),
      onTap: () {
        _selectTime(context);
      },
      builder: (BuildContext context) => TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        enabled: false,
        style: TextStyle(fontSize: 26),
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        controller: _timeController,
      ),
    );
  }

  Widget _buildPriceField() {
    return ServiceSettingField(
      serviceLabel: Text('What is the price for this service'),
      builder: (BuildContext context) => TextFormField(
        controller: _priceController,
        onSaved: (String v) {
          _serviceSetting.price = double.tryParse(v);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          hintText: 'price',
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (String v) {
          if (v.isEmpty || v == '0') {
            return 'Price can not be empty';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildServiceDatePicker() {
    return ServiceSettingField(
      serviceLabel: Text('Pick a date for this service'),
      builder: (BuildContext context) => TextFormField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        controller: _dateController,
        validator: (String v) {
          if (v.isEmpty) {
            return 'Service date can not be empty';
          }

          return null;
        },
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _serviceSetting.serviceDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(now.day + 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        _serviceSetting.serviceDate = picked;
        _dateController.text =
            DateFormat.yMd().format(_serviceSetting.serviceDate);
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _serviceSetting.serviceTime,
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (picked != null) {
      _serviceSetting.serviceTime = picked;
      setState(() {
        _timeController.text = formatDate(
          DateTime(
            _serviceSetting.serviceDate.year,
            _serviceSetting.serviceDate.month,
            _serviceSetting.serviceDate.day,
            _serviceSetting.serviceTime.hour,
            _serviceSetting.serviceTime.minute,
          ),
          [hh, ':', nn, " ", am],
        ).toString();
      });
    }
  }
}
