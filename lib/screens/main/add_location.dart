import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/controller/firebase_controller.dart';
import 'package:np_parking/screens/add_location_details.dart';
import 'package:np_parking/screens/search.dart';
import 'package:np_parking/screens/widgets/circular_indicator.dart';

const LatLng currentLocation1 = LatLng(27.679213, 85.398276);

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final AddController _addController = Get.put(AddController());

  var position = Offset(97.3, 435.3);

  Map<String, Marker> allMarker = {
    // "0": const Marker(
    //   markerId: MarkerId("0"),
    //   position: destinationLocation,
    // ),
  };

  @override
  void initState() {
    if (_addController.currentLocation == null) {
      _addController.getCurrentLocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _addController.loading.value
            ? Center(child: circularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 600,
                      // height: 100,
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: _addController.googleMaptype.value,
                            onCameraMove: (position) {
                              print(position);
                              _addController.latlng = position.target;
                            },
                            onMapCreated: (controller) {
                              //method called when map is created
                              setState(() {
                                _addController.googleMapController = controller;
                              });
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  _addController.currentLocation!.latitude!,
                                  _addController.currentLocation!.longitude!),
                              zoom: 19,
                            ),
                            myLocationEnabled: true,
                            compassEnabled: false,
                            markers: allMarker.values.toSet(),

                            onLongPress: (taplatlng) async {
                              geolocator.Position currentPosition =
                                  await geolocator.Geolocator
                                      .getCurrentPosition(
                                          desiredAccuracy:
                                              geolocator.LocationAccuracy.best);

                              print(allMarker.length);
                              print(taplatlng.latitude);
                              print(taplatlng.longitude);

                              allMarker.addAll({
                                "${allMarker.length}": Marker(
                                  markerId: MarkerId("${allMarker.length}"),
                                  position: LatLng(
                                      taplatlng.latitude, taplatlng.longitude),
                                )
                              });
                              setState(() {});
                            },
                            // markers: {
                            //   const Marker(
                            //     markerId: MarkerId("destination"),
                            //     position: destinationLocation,
                            //   ),
                            // },
                          ),

                          // Map type Normal and Satellite button
                          Align(
                            alignment: const Alignment(0.94, 0.72),
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              elevation: 1,
                              shape: ShapeBorder.lerp(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                0,
                              ),
                              onPressed: () {
                                print("akjsdkfjlkajsdfa");
                                print(_addController.googleMaptype);

                                if (_addController.googleMaptype.value ==
                                    MapType.normal) {
                                  _addController.googleMaptype.value =
                                      MapType.satellite;
                                } else {
                                  _addController.googleMaptype.value =
                                      MapType.normal;
                                }
                              },
                              child: const Icon(Icons.layers),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0, -0.08),
                            child: Draggable(
                              onDragEnd: (details) {
                                setState(() {
                                  position = details.offset;
                                });
                              },
                              feedbackOffset: const Offset(97.3, 435.3),
                              feedback: const Icon(
                                color: Colors.red,
                                Icons.location_pin,
                                size: 70,
                              ),
                              childWhenDragging: SizedBox(),
                              // onDraggableCanceled: (velocity, offset) => setState(() {
                              //   print("Draggable Canceled");
                              //   print(offset);
                              // }),
                              child: const Icon(
                                color: Colors.red,
                                Icons.location_pin,
                                size: 70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add this position Bottom Sheet
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                              onPressed: () async {
                                await _addController.fetchRealAddress();

                                locationDetailsBottomSheet(context);
                                // allMarker.addAll({
                                //   "${allMarker.length}": Marker(
                                //     markerId: MarkerId("${allMarker.length}"),
                                //     position: LatLng(
                                //         latlng.latitude, latlng.longitude),
                                //   )
                                // });
                                // setState(() {});
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  "Add this position",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
