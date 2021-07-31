import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/inquiry_form.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';

class CreateInquiry extends StatefulWidget {
  @override
  _CreateInquiryState createState() => _CreateInquiryState();
}

class _CreateInquiryState extends State<CreateInquiry> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _buildHeader(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _searchButton(),
        ],
      ),
    );
  }

  Widget _searchButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LoadInquiryBloc(
                      searchInquiryAPIs: SearchInquiryAPIs(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => SearchInquiryFormBloc(
                      searchInquiryAPIs: SearchInquiryAPIs(),
                      loadInquiryBloc:
                          BlocProvider.of<LoadInquiryBloc>(context),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => LoadServiceListBloc(
                      searchInquiryAPIs: SearchInquiryAPIs(),
                    ),
                  ),
                ],
                child: InquiryForm(),
              );
            },
          ),
        ).then((value) {
          setState(() {
            BlocProvider.of<LoadInquiryBloc>(context).add(LoadInquiry());
          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(31, 30, 56, 1),
        ),
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        height: 45,
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(119, 81, 255, 1),
          elevation: 7,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: Text(
                    '去提需求',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child:
                      Image.asset("lib/screens/male/assets/search_arrow.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: 30,
        right: 16,
        left: 16,
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/panda_head_logo.png'),
            width: 31,
            height: 31,
          ),
          SizedBox(width: 8),
          Text(
            '您目前暫無需求',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
