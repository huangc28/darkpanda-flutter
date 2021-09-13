import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/enums/service_types.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/components/service_settings/service_settings_sheet.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/models/inquiry_forms.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/models/service_list.dart';
import 'package:darkpanda_flutter/screens/address_selector/address_selector.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'inquiry_appointment_time_field.dart';

// @TODOs
//  - duration list should be coming from the API.
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedIndexServiceType = 0;
  int selectedIndexPeriod = 0;

  TextEditingController _budgetController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _serviceTypeController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  List serviceTypeRadioWidget = <Widget>[];

  LoadServiceListBloc loadServiceListBloc = new LoadServiceListBloc();
  ServiceList serviceList = new ServiceList();

  InquiryForms _inquiryForms = InquiryForms(
    inquiryDate: DateTime.now(),
    inquiryTime: TimeOfDay(hour: 00, minute: 00),
    duration: Duration(hours: 1, minutes: 0),
  );

  DateTime dateTime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay(hour: 00, minute: 00);

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoadServiceListBloc>(context).add(LoadServiceList());

    _dateController.text = _formatDate(_inquiryForms.inquiryDate);
    _timeController.text = _formatTime(
      _inquiryForms.inquiryTime,
    );

    _durationController.text = '30';
    _addressController.text = '';
    serviceList.serviceNames = [];
  }

  @override
  void dispose() {
    loadServiceListBloc.add(ClearServiceListState());
    _budgetController.clear();
    _dateController.clear();
    _timeController.clear();
    _serviceTypeController.clear();
    _durationController.clear();
    _addressController.clear();

    super.dispose();
  }

  void initServiceTypeRadio(list) {
    serviceTypeRadioWidget.clear();
    for (int i = 0; i < list.length; i++) {
      serviceTypeRadioWidget.add(
        SizedBox(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
            child: _customServiceTypeRadio(list[i].name, i),
          ),
        ),
      );
    }
  }

  void changeIndexServiceType(int index) {
    setState(() {
      selectedIndexServiceType = index;
    });
  }

  void changeIndexPeriod(int index) {
    setState(() {
      selectedIndexPeriod = index;
    });
  }

  String _formatDate(DateTime dateTime) =>
      DateFormat.yMd().format(_inquiryForms.inquiryDate);

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();

    return formatDate(
      DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
        0,
      ),
      [hh, ':', nn, " ", am],
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    final viewPortHeight = MediaQuery.of(context).size.height;
    initServiceTypeRadio(serviceList.serviceNames);

    return UnfocusPrimary(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: viewPortHeight * 0.02),
                  _budgetInput(),
                  SizedBox(height: viewPortHeight * 0.05),
                  _textLabel('服務類型'),
                  SizedBox(height: viewPortHeight * 0.02),
                  _serviceTypeRadio(),
                  SizedBox(height: viewPortHeight * 0.02),
                  _textLabel('見面時間'),
                  SizedBox(height: viewPortHeight * 0.02),
                  _appointmentTime(),
                  SizedBox(height: viewPortHeight * 0.02),
                  _servicePeriod(),
                  SizedBox(height: viewPortHeight * 0.02),
                  GestureDetector(
                    onTap: _navigateToAddressSelector,
                    child: Container(
                      color: Colors.transparent,
                      child: IgnorePointer(
                        child: AddressField(
                          controller: _addressController,
                          fontColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '請選擇地址';
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: viewPortHeight * 0.05),
                  _confirmButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAddressSelector() async {
    FocusScope.of(context).requestFocus(FocusNode());

    final addr = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AddressSelector(
            initialAddress: _addressController.text,
          );
        },
      ),
    );

    setState(() {
      _addressController.text = addr;

      _inquiryForms.address = _addressController.text;
    });
  }

  Widget _confirmButton() {
    return BlocListener<SearchInquiryFormBloc, SearchInquiryFormState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.loading ||
            state.status == AsyncLoadingStatus.initial) {
          setState(() {
            isLoading = true;
          });
        } else if (state.status == AsyncLoadingStatus.error) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        } else if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: DPTextButton(
        loading: isLoading,
        disabled: isLoading,
        theme: DPTextButtonThemes.purple,
        onPressed: () async {
          if (!_formKey.currentState.validate()) {
            return;
          }

          _formKey.currentState.save();

          BlocProvider.of<SearchInquiryFormBloc>(context).add(
            SubmitSearchInquiryForm(_inquiryForms),
          );
        },
        text: '提交需求',
      ),
    );
  }

  Widget _appointmentTime() {
    return Container(
      child: InquiryAppointmentTimeField(
        dateController: _dateController,
        timeController: _timeController,
        dateValue: dateTime,
        timeValue: timeOfDay,
        onSelectDate: (DateTime dateTime) {
          setState(() {
            _inquiryForms.inquiryDate = dateTime;
            _dateController = TextEditingController()
              ..text = _formatDate(_inquiryForms.inquiryDate);
          });
        },
        onSelectTime: (TimeOfDay time) {
          setState(() {
            _inquiryForms.inquiryTime = time;
            _timeController = TextEditingController()..text = _formatTime(time);
          });
        },
      ),
    );
  }

  Widget _servicePeriod() {
    return ServiceDurationField(
      controller: _durationController,
      fontColor: Colors.white,
      validator: (String v) {
        if (v == null || v.isEmpty) {
          return '請輸入服務時長';
        }

        final doubleDuration = double.tryParse(v);

        if (doubleDuration < 30.0) {
          return '服務時長最少 30 分鐘';
        }

        // Check if user input contains decimal fraction.
        final fraction = doubleDuration - doubleDuration.truncate();

        if (fraction > 0) {
          return '服務時長必須為整數';
        }

        return null;
      },
      onSaved: (String v) {
        // Convert duration value to Duration instance.
        setState(
          () {
            _inquiryForms.duration =
                Duration(minutes: int.tryParse(_durationController.text));
          },
        );
      },
    );
  }

  Widget _serviceTypeRadio() {
    return BlocConsumer<LoadServiceListBloc, LoadServiceListState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            serviceList = state.serviceList;
            _serviceTypeController.text = serviceList.serviceNames[0].name;
            _inquiryForms.serviceType = _serviceTypeController.text;
          });
        }
      },
      builder: (context, state) {
        if (state.status == AsyncLoadingStatus.done) {
          return Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: serviceTypeRadioWidget,
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _customServiceTypeRadio(String txt, int index) {
    return OutlinedButton(
      onPressed: () {
        changeIndexServiceType(index);
        _serviceTypeController.text = serviceList.serviceNames[index].name;
        _inquiryForms.serviceType = _serviceTypeController.text;
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:
            selectedIndexServiceType == index ? Colors.white : Colors.black,
        side: BorderSide(
          color: Color.fromRGBO(106, 109, 137, 1),
        ),
      ),
      child: txt == ServiceTypes.sex.name
          ? Icon(
              Icons.favorite,
              color: Colors.pink,
            )
          : Text(
              txt,
              style: TextStyle(
                color: selectedIndexServiceType == index
                    ? Colors.black
                    : Colors.white,
              ),
            ),
    );
  }

  Widget _budgetInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: TextFormField(
        controller: _budgetController,
        validator: (String v) {
          return v.isEmpty || v == '0' ? 'Budget can not be empty' : null;
        },
        onSaved: (value) {
          _inquiryForms.budget = double.tryParse(value);
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          hintText: "請輸入您的預算",
          hintStyle: TextStyle(
            color: Color.fromRGBO(106, 109, 137, 1),
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            borderSide: BorderSide.none,
          ),
          fillColor: Color.fromRGBO(255, 255, 255, 0.1),
          filled: true,
        ),
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _textLabel(String text) => Bullet(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
}
