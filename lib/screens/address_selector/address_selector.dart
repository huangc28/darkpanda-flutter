import 'package:flutter/material.dart';

import 'package:darkpanda_flutter/components/dp_text_form_field.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressSelector extends StatefulWidget {
  AddressSelector({Key key}) : super(key: key);

  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  // GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // Top search bar
              Container(
                padding: EdgeInsets.only(
                  top: 40,
                  right: 16,
                ),
                child: Row(
                  children: [
                    // Back button.
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      iconSize: 25,
                      color: Color.fromRGBO(106, 109, 137, 1),
                    ),

                    // Search content.
                    Expanded(
                      child: Container(
                        height: 34,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.0)),
                            ),
                            contentPadding:
                                EdgeInsets.only(bottom: 12, left: 10),
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 0.1),
                            hintText: '輸入地址',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.3,
                              color: Color.fromRGBO(106, 109, 137, 1),
                            ),
                          ),
                        ),
                      ),
                    ),


                    // Map icon button.
                    IconButton(
                      onPressed: () {
                        print('');

                      },

                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
