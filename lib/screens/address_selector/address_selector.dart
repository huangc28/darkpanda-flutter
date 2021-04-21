import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:easy_debounce/easy_debounce.dart';

import './services/apis.dart';
import './bloc/determine_location_bloc.dart';
import './bloc/determine_address_bloc.dart';
import './screen_arguments/address_selector_args.dart';
import './models/location.dart';

part 'components/address_map.dart';

class AddressSelector extends StatelessWidget {
  const AddressSelector({
    Key key,
    this.args,
    this.initialAddress,
  }) : super(key: key);

  final AddressSelectorArgs args;
  final String initialAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => DetermineLocationBloc(
                apiClient: AddressSelectorAPIClient(),
              ),
            ),
            BlocProvider(
              create: (_) => DetermineAddressBloc(
                apiClient: AddressSelectorAPIClient(),
              ),
            ),
          ],
          // Dispatch event to load inquiry position in coordinate. If position is not provided, use current position instead.
          child: AddressMap(
            address: initialAddress,
          ),
        ),
      ),
    );
  }
}
