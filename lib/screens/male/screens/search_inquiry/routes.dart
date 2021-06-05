import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/inquiry_form.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry/search_inquiry.dart';
import 'package:flutter/material.dart';

import '../waiting_inquiry/waiting_inquiry.dart';

class SearchInquiryRoutes extends BaseRoutes {
  static const root = '/';
  static const inquiry_form = '/inquiry-form';
  static const waiting_inquiry = '/waiting-inquiry';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SearchInquiryRoutes.root: (contect) => SearchInquiry(
            onPush: (String routeName) => this.push(context, routeName, args),
          ),
      SearchInquiryRoutes.inquiry_form: (context) => InquiryForm(),
      SearchInquiryRoutes.waiting_inquiry: (context) => WaitingInquiry(),
    };
  }
}
