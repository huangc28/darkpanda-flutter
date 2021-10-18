import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:darkpanda_flutter/util/convertZeroDecimalToInt.dart';
import 'package:darkpanda_flutter/components/bullet.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/enums/service_types.dart';
import 'package:darkpanda_flutter/screens/address_selector/address_selector.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/components/service_settings/service_settings.dart';

import 'package:darkpanda_flutter/components/unfocus_primary.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/models/inquiry_forms.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/models/service_list.dart';

import 'body.dart';

class EditBody extends StatefulWidget {
  const EditBody({
    this.activeInquiry,
  });

  final ActiveInquiry activeInquiry;

  @override
  _EditBodyState createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
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

    _inquiryForms.uuid = widget.activeInquiry.uuid;
    _budgetController.text = widget.activeInquiry.budget == null
        ? '0'
        : convertZeroDecimalToInt(widget.activeInquiry.budget);

    // Convert string date into Date format
    if (widget.activeInquiry.appointmentTime != null) {
      String date = widget.activeInquiry.appointmentTime;
      dateTime = DateTime.parse(date).toLocal();
      timeOfDay = TimeOfDay.fromDateTime(dateTime);
    }

    _dateController.text = widget.activeInquiry.appointmentTime == null
        ? _formatDate(_inquiryForms.inquiryDate)
        : _formatDate(dateTime);

    _timeController.text = widget.activeInquiry.appointmentTime == null
        ? _formatTime(timeOfDay)
        : _formatTime(timeOfDay);
    ;

    _durationController.text = widget.activeInquiry.duration.toString();
    _addressController.text = widget.activeInquiry.address;

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

  String _formatDate(DateTime dateTime) {
    return DateFormat.yMd().format(dateTime);
  }

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

  @override
  Widget build(BuildContext context) {
    final viewPortWidth = MediaQuery.of(context).size.width;
    final viewPortHeight = MediaQuery.of(context).size.height;
    initServiceTypeRadio(serviceList.serviceNames);

    return UnfocusPrimary(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (20.0 / 375.0) * viewPortWidth),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: viewPortHeight * 0.05),
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
            SubmitEditSearchInquiryForm(_inquiryForms),
          );
        },
        text: '編輯',
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
            // _serviceTypeController.text = serviceList.serviceNames[0].name;
            // _inquiryForms.serviceType = _serviceTypeController.text;

            // To get index of selected value from widget.activeInquiry.serviceType
            // If widget.activeInquiry.serviceType is null, get the first index
            final index = serviceList.serviceNames.indexWhere((element) =>
                element.name ==
                (widget.activeInquiry.serviceType == null
                    ? serviceList.serviceNames[0].name
                    : widget.activeInquiry.serviceType));

            _serviceTypeController.text =
                widget.activeInquiry.serviceType == null
                    ? serviceList.serviceNames[0].name
                    : widget.activeInquiry.serviceType;

            _inquiryForms.serviceType = _serviceTypeController.text;

            changeIndexServiceType(index);
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
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
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

  Widget _textLabel(String text) {
    return Bullet(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}
