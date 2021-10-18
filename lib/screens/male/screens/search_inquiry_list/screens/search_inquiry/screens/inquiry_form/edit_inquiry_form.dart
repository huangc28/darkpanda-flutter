import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/models/active_inquiry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/edit_body.dart';

class EditInquiryForm extends StatefulWidget {
  const EditInquiryForm({
    this.onPush,
    this.activeInquiry,
  });

  final Function(String) onPush;
  final ActiveInquiry activeInquiry;

  @override
  State<EditInquiryForm> createState() => _EditInquiryFormState();
}

class _EditInquiryFormState extends State<EditInquiryForm> {
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
            Navigator.of(context).pop(null);
          }
        },
        builder: (context, state) {
          return EditBody(
            activeInquiry: widget.activeInquiry,
          );
        },
      ),
    );
  }
}
