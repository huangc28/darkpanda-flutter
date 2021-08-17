import 'package:darkpanda_flutter/models/service_settings.dart';
import 'package:darkpanda_flutter/screens/chatroom/screens/inquiry/bloc/get_inquiry_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/models/auth_user.dart';

import 'components/body.dart';

class MaleInquiryDetail extends StatefulWidget {
  const MaleInquiryDetail({
    this.inquiryUuid,
    this.authUser,
    Key key,
  }) : super(key: key);

  final String inquiryUuid;
  final AuthUser authUser;

  @override
  _MaleInquiryDetailState createState() => _MaleInquiryDetailState();
}

class _MaleInquiryDetailState extends State<MaleInquiryDetail> {
  ServiceSettings _serviceSettings;

  AsyncLoadingStatus _serviceDetailStatus = AsyncLoadingStatus.initial;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<GetInquiryBloc>(context).add(
      GetInquiry(inquiryUuid: widget.inquiryUuid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetInquiryBloc, GetInquiryState>(
      listener: (context, state) {
        if (state.status == AsyncLoadingStatus.error) {
          developer.log(
            'failed to fetch payment detail',
            error: state.error,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.message),
            ),
          );
        }

        if (state.status == AsyncLoadingStatus.done) {
          setState(() {
            _serviceSettings = state.serviceSettings;
          });
        }

        setState(() {
          _serviceDetailStatus = state.status;
        });
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
        appBar: AppBar(
          title: Text('交易'),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(106, 109, 137, 1), //change your color here
          ),
        ),
        body: Body(
          serviceSettings: _serviceSettings,
          authUser: widget.authUser,
          serviceDetailStatus: _serviceDetailStatus,
        ),
      ),
    );
  }
}
