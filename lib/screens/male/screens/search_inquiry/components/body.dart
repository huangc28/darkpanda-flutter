import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/inquiry_form.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';

class Body extends StatefulWidget {
  const Body({this.onPush});

  final Function(String) onPush;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(31, 30, 56, 1),
      ),
      padding: EdgeInsets.only(top: 0, left: 20, right: 20),
      height: 45,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(119, 81, 255, 1),
        elevation: 7,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => SearchInquiryFormBloc(
                          searchInquiryAPIs: SearchInquiryAPIs(),
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
            );
          },
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
