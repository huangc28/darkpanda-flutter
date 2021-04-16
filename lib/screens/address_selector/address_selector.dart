import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';

import './bloc/determine_location_bloc.dart';
import './screen_arguments/address_selector_args.dart';

part 'components/address_map.dart';

class AddressSelector extends StatelessWidget {
  const AddressSelector({
    Key key,
    this.args,
  }) : super(key: key);

  final AddressSelectorArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) => DetermineLocationBloc(),
          child: AddressMap(),
        ),
      ),
    );
  }
}
