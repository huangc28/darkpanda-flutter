import 'package:darkpanda_flutter/base_routes.dart';
import 'package:darkpanda_flutter/screens/male/bloc/agree_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/cancel_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_inquiry_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/load_service_list_bloc.dart';
import 'package:darkpanda_flutter/screens/male/bloc/search_inquiry_form_bloc.dart';
import 'package:darkpanda_flutter/screens/male/screens/inquiry_form/inquiry_form.dart';
import 'package:darkpanda_flutter/screens/male/screens/search_inquiry/search_inquiry.dart';
import 'package:darkpanda_flutter/screens/male/services/search_inquiry_apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchInquiryRoutes extends BaseRoutes {
  static const root = '/';
  static const inquiry_form = '/inquiry-form';

  Map<String, WidgetBuilder> routeBuilder(BuildContext context, [Object args]) {
    return {
      SearchInquiryRoutes.root: (contect) => MultiProvider(
            providers: [
              BlocProvider(
                create: (context) => CancelInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                ),
              ),
              BlocProvider(
                create: (context) => LoadInquiryBloc(
                  searchInquiryAPIs: SearchInquiryAPIs(),
                ),
              ),
            ],
            child: SearchInquiry(
              onPush: (String routeName) => this.push(context, routeName, args),
            ),
          ),
      SearchInquiryRoutes.inquiry_form: (context) {
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
                loadInquiryBloc: BlocProvider.of<LoadInquiryBloc>(context),
              ),
            ),
            BlocProvider(
              create: (context) => LoadServiceListBloc(
                searchInquiryAPIs: SearchInquiryAPIs(),
              ),
            ),

            // BlocProvider(
            //   create: (context) => AgreeInquiryBloc(
            //     searchInquiryAPIs: SearchInquiryAPIs(),
            //   ),
            // ),
          ],
          child: InquiryForm(
            onPush: (String routeName) => this.push(context, routeName, args),
          ),
        );
      },
    };
  }
}
