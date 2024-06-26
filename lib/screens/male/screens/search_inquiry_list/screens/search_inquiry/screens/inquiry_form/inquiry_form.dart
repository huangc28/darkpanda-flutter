import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/util/firebase_messaging_service.dart';

import 'components/body.dart';
import 'models/inquiry_forms.dart';

class InquiryForm extends StatefulWidget {
  const InquiryForm({
    this.onPush,
  });

  final Function(String) onPush;

  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  AsyncLoadingStatus _inquiryFormStatus = AsyncLoadingStatus.initial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('編輯需求'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
        backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      ),
      backgroundColor: Color.fromRGBO(17, 16, 41, 1),
      body: BlocConsumer<SearchInquiryFormBloc, SearchInquiryFormState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          } else if (state.status == AsyncLoadingStatus.done) {
            if (state.createInquiryResponse.fcmTopic != null) {
              FirebaseMessagingService()
                  .fcmSubscribe(state.createInquiryResponse.fcmTopic);
              print('FCM topic: ' + state.createInquiryResponse.fcmTopic);
            }

            Navigator.of(context).pop(null);
          }

          setState(() {
            _inquiryFormStatus = state.status;
          });
        },
        builder: (context, state) {
          return Body(
            onSubmit: _handleSubmit,
            inquiryFormStatus: _inquiryFormStatus,
          );
        },
      ),
    );
  }

  _handleSubmit(InquiryForms inquiryForms) {
    BlocProvider.of<SearchInquiryFormBloc>(context).add(
      SubmitSearchInquiryForm(inquiryForms),
    );
  }
}
