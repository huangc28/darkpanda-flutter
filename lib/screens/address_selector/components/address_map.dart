part of '../address_selector.dart';

/// We reference this article: https://stackoverflow.com/questions/53652573/fix-google-map-marker-in-center
/// to center the marker at the middle of the map.
/// TODO:
///   - Extract the search action from this widget.
class AddressMap extends StatefulWidget {
  AddressMap({
    Key key,
    this.address,
    @required this.onConfirmAddress,
  }) : super(key: key);

  final String address;
  final ValueChanged<String> onConfirmAddress;

  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  TextEditingController _addressController = TextEditingController();

  /// Keep track on the focus status of address text field. If address text field
  /// is on focus, we should display  button to search address instead of confirm
  /// address.
  FocusNode _addressFieldFocusNode = FocusNode();

  /// State to keep track on the focus status of address text field.
  bool _addressFieldHasFocus = false;

  /// Result address selected by the user.
  String _address;

  static const _markerId = 'currentPos';

  /// Location determined by the [DetermineLocationBloc]. We will show
  /// this location marker on the map.
  Location _location;

  /// We will make a marker on the map.
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();

    _address = widget.address;

    BlocProvider.of<DetermineLocationBloc>(context).add(
      DetermineLocationFromAddress(address: _address),
    );

    _addressController.text = widget.address;

    _addressFieldFocusNode.addListener(_onAddressFieldFocusChange);
  }

  void _onAddressFieldFocusChange() {
    setState(() {
      _addressFieldHasFocus = _addressFieldFocusNode.hasFocus;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    final markerId = MarkerId(_markerId);

    final marker = Marker(
      markerId: markerId,
      position: LatLng(
        _location.latitude,
        _location.longtitude,
      ),
      draggable: false,
    );

    setState(() {
      _markers[markerId] = marker;
    });
  }

  Widget _buildGoogleMap(Location location) {
    return GoogleMap(
      markers: Set<Marker>.of(_markers.values),
      onMapCreated: _onMapCreated,
      onTap: (_) {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();

          // Emit event to update position on the map.
        }
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          location.latitude,
          location.longtitude,
        ),
        zoom: 18.0,
      ),
      onCameraMove: (CameraPosition position) {
        // We update the marker position here
        final markerId = MarkerId(_markerId);
        final marker = _markers[markerId];
        final updatedMarker = marker.copyWith(
          positionParam: position.target,
        );

        // We will dispatch an event to retrieve address based on coordinate.
        // Update the content of address field with retrieved address.
        EasyDebounce.debounce(
          'determine_address_debouncer',
          Duration(milliseconds: 500),
          () => BlocProvider.of<DetermineAddressBloc>(context).add(
            DetermineAddressFromLocation(
              latitude: position.target.latitude,
              longtitude: position.target.longitude,
            ),
          ),
        );

        setState(() {
          _markers[markerId] = updatedMarker;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Display google map. The map display sector should be relatively small.
                // We need to display loading spinner when location is being loaded.
                Expanded(
                  flex: 6,
                  child: BlocConsumer<DetermineLocationBloc,
                      DetermineLocationState>(
                    listener: (context, state) {
                      if (state.status == AsyncLoadingStatus.done) {
                        setState(() {
                          _location = state.location;
                          _address = _addressController.text;
                        });

                        _addressFieldFocusNode.unfocus();
                      }

                      if (state.status == AsyncLoadingStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('地址搜尋失敗'),
                          ),
                        );

                        _addressFieldFocusNode.unfocus();
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 244, 246, 1),
                        ),
                        child: state.status == AsyncLoadingStatus.done
                            ? _buildGoogleMap(state.location)
                            : Container(
                                child: LoadingIcon(
                                  color: Colors.black54,
                                ),
                              ),
                      );
                    },
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(27, 7, 27, 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.26),
                              spreadRadius: 0,
                              blurRadius: 16,
                              offset:
                                  Offset(0, 15), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Description.
                            Text(
                              '移動地圖來定位',
                              style: TextStyle(
                                color: Color.fromRGBO(139, 144, 154, 1),
                                fontSize: 14,
                              ),
                            ),

                            SizedBox(height: 6),

                            // Search content.
                            BlocListener<DetermineAddressBloc,
                                DetermineAddressState>(
                              listener: (context, state) {
                                if (state.status == AsyncLoadingStatus.done) {
                                  setState(() {
                                    _address = state.address.address;
                                  });

                                  _addressController.text =
                                      state.address.address;
                                }
                              },
                              child: Container(
                                height: 36,
                                child: DPTextFormField(
                                  focusNode: _addressFieldFocusNode,
                                  theme: DPTextFieldThemes.inquiryForm,
                                  hintText: '請輸入地址',
                                  controller: _addressController,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            // Submit address button.
                            DPTextButton(
                              theme: DPTextButtonThemes.purple,
                              onPressed: () {
                                _addressFieldHasFocus
                                    ? BlocProvider.of<DetermineLocationBloc>(
                                            context)
                                        .add(DetermineLocationFromAddress(
                                            address: _addressController.text))
                                    : widget.onConfirmAddress(_address);
                              },
                              text: _addressFieldHasFocus ? '搜尋' : '確認地址',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 34,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
