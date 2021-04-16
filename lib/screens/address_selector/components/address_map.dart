part of '../address_selector.dart';

class AddressMap extends StatefulWidget {
  AddressMap({Key key}) : super(key: key);

  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  final LatLng _center = const LatLng(45.521563, -122.677433);

  GoogleMapController _mapController;
  TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Display google map. The map display sector should be relatively small.
                Expanded(
                  flex: 4,
                  child: Container(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 20.0,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 244, 246, 1),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                            Container(
                              height: 36,
                              child: DPTextFormField(
                                theme: DPTextFieldThemes.inquiryForm,
                                hintText: '請輸入地址',
                                controller: _addressController,
                              ),
                            ),

                            SizedBox(height: 6),

                            // Submit address button.
                            DPTextButton(
                              theme: DPTextButtonThemes.purple,
                              onPressed: () {},
                              text: '確認地址',
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
