import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/util/firebase_messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/body.dart';

class InquiryForm extends StatefulWidget {
  const InquiryForm({
    this.onPush,
  });

  final Function(String) onPush;

  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('編輯需求 ~'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
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
            }

            Navigator.of(context).pop(null);
          }
        },
        builder: (context, state) {
          return Body();
        },
      ),
    );
  }
}
