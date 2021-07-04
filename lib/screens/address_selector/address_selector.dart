import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:darkpanda_flutter/components/dp_button.dart';
import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
import 'package:darkpanda_flutter/components/loading_icon.dart';
import 'package:darkpanda_flutter/enums/async_loading_status.dart';
import 'package:easy_debounce/easy_debounce.dart';

import './services/apis.dart';
import './bloc/determine_location_bloc.dart';
import './bloc/determine_address_bloc.dart';
import './models/location.dart';

part 'components/address_map.dart';

class AddressSelector extends StatelessWidget {
  const AddressSelector({
    Key key,
    this.initialAddress,
    this.onConfirmAddress,
  }) : super(key: key);

  final String initialAddress;
  final ValueChanged<String> onConfirmAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => DetermineLocationBloc(
                    apiClient: AddressSelectorAPIClient(),
                  )),
          BlocProvider(
              create: (_) => DetermineAddressBloc(
                    apiClient: AddressSelectorAPIClient(),
                  )),
        ],
        child: SafeArea(
          child: AddressMap(
            address: initialAddress,
            onConfirmAddress: (address) {
              Navigator.pop<String>(context, address);
            },
          ),
        ),
      ),
    );
  }
}
