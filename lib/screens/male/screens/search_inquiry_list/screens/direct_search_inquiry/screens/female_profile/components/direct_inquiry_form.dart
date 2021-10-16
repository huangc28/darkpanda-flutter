import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/direct_search_inquiry/bloc/direct_inquiry_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';

import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/components/body.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry_list/screens/search_inquiry/screens/inquiry_form/models/inquiry_forms.dart';

class DirectInquiryForm extends StatefulWidget {
  const DirectInquiryForm({
    this.onPush,
    this.uuid,
  });

  final Function(String) onPush;
  final String uuid;

  @override
  State<DirectInquiryForm> createState() => _DirectInquiryForm();
}

class _DirectInquiryForm extends State<DirectInquiryForm> {
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
      body: BlocConsumer<DirectInquiryFormBloc, DirectInquiryFormState>(
        listener: (context, state) {
          if (state.status == AsyncLoadingStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.message),
              ),
            );
          } else if (state.status == AsyncLoadingStatus.done) {
            Navigator.of(context).pop(state.createInquiryResponse);
          }

          setState(() {
            _inquiryFormStatus = state.status;
          });
        },
        builder: (context, state) {
          return Body(
            onSubmit: _handleSubmit,
            inquiryFormStatus: _inquiryFormStatus,
            submitButtonText: '馬上聊聊',
          );
        },
      ),
    );
  }

  _handleSubmit(InquiryForms inquiryForms) {
    inquiryForms.uuid = widget.uuid;

    BlocProvider.of<DirectInquiryFormBloc>(context).add(
      SubmitDirectInquiryForm(inquiryForms),
    );
  }
}
