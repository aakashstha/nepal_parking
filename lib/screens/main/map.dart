import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/controller/firebase_controller.dart';
import 'package:np_parking/controller/map_controller.dart';
import 'package:np_parking/model/add_location_details_model.dart';
import 'package:np_parking/screens/add_location_details.dart';
import 'package:np_parking/screens/all_list.dart';
import 'package:np_parking/screens/search.dart';
import 'package:get/get.dart';
import 'package:np_parking/screens/widgets/circular_indicator.dart';

class HomePage extends StatefulWidget {
  bool isSearch;
  HomePage({super.key, this.isSearch = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double sheetHeight = 150;
  final MapController _mapController = Get.put(MapController());
  final FirebaseController _firebaseController = Get.put(FirebaseController());
  // late AddLocationDetailsModel _individualLocationDetails;

  @override
  void initState() {
    if (_mapController.currentLocation == null) {
      _mapController.getCurrentLocation();
    }
    _mapController.addAllLocationMarkerandDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _mapController.loading.value
            ? Center(child: circularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    padding: const EdgeInsets.only(top: 110.0, bottom: 160),
                    onMapCreated: (controller) {
                      _mapController.googleMapController = controller;

                      // // Testing
                      // addMarkers(
                      //   "test",
                      //   LatLng(_mapController.currentLocation!.latitude!,
                      //       _mapController.currentLocation!.longitude!),
                      // );
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_mapController.currentLocation!.latitude!,
                          _mapController.currentLocation!.longitude!),
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    markers: _mapController.allMarker1.values.toSet(),
                  ),
                  Positioned(
                    top: 60,
                    right: -8,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Search()),
                        );
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.search,
                        size: 25.0,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, -0.84),
                    child: RawMaterialButton(
                      onPressed: () {
                        print(_mapController.individualLocationDetails.value
                            .openingTime.isEmpty);
                        // _firebaseController
                        //     .deleteLocationDetails("PETZukI6VuQFU7Vnl5D6");
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const AllList(),
                        //   ),
                        // );
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: const Text(
                        "All list",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 240,
                    right: -5,
                    child: RawMaterialButton(
                      onPressed: () async {
                        print(_mapController.allMarker1);

                        // await _mapController.addAllLocationMarkerandDetails();
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.refresh,
                        size: 25.0,
                      ),
                    ),
                  ),

                  // "Position details" Bottom Sheet

                  !_mapController.showBottomSheet.value
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              // Update the height of the bottom sheet based on drag gesture
                              setState(() {
                                sheetHeight -= details.primaryDelta!;

                                print(details.primaryDelta!);
                                if (sheetHeight < 150) {
                                  sheetHeight = 150; // Minimum height
                                } else if (sheetHeight > 420) {
                                  sheetHeight = 420; // Maximum height
                                }
                              });
                            },
                            child: Container(
                              height: sheetHeight,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset.zero,
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 15),
                                      Center(
                                        child: Container(
                                          width: 40,
                                          height: 4,
                                          color: Color.fromARGB(
                                              255, 129, 129, 129),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Text(
                                        _mapController.individualLocationDetails
                                            .value.placeName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),

                                      // Charge
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Charge - ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFa7f0ba),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  _mapController
                                                      .individualLocationDetails
                                                      .value
                                                      .charge
                                                      .capitalizeFirst!,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 14, 79, 201),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Vehicle
                                      Row(
                                        children: [
                                          const Text(
                                            "Vehicle - ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ...List.generate(
                                                _mapController
                                                    .individualLocationDetails
                                                    .value
                                                    .vehicle
                                                    .length,
                                                (index) => Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFa7f0ba),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: Text(
                                                      _mapController
                                                          .individualLocationDetails
                                                          .value
                                                          .vehicle[index]
                                                          .toString()
                                                          .capitalizeFirst!,
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 14, 79, 201),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),

                                      // Location Type
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Location Type - ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFa7f0ba),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  _mapController
                                                      .individualLocationDetails
                                                      .value
                                                      .locationType
                                                      .capitalizeFirst!,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 14, 79, 201),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Opening Days
                                      const Text(
                                        "Opening",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),

                                      _mapController.individualLocationDetails
                                              .value.openingDays.isEmpty
                                          ? const Text(
                                              "Day - Not Provided",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : _mapController
                                                      .individualLocationDetails
                                                      .value
                                                      .openingDays
                                                      .length ==
                                                  7
                                              ? const Text(
                                                  "Day - Everyday",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Text(
                                                  "Day - ${_mapController.individualLocationDetails.value.openingDays.map((day) => day.substring(0, 3)).join(', ')}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),

                                      // Time
                                      _mapController.individualLocationDetails
                                              .value.isAllDayOpen
                                          ? const Text(
                                              "Time - 24 hours",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : _mapController
                                                  .individualLocationDetails
                                                  .value
                                                  .openingTime
                                                  .isEmpty
                                              ? const Text(
                                                  "Time - Not Provided",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Text(
                                                  "Time - ${_mapController.individualLocationDetails.value.openingTime} to ${_mapController.individualLocationDetails.value.closingTime}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),

                                      const SizedBox(height: 15),
                                      // Update Button
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: TextButton(
                                          onPressed: () async {
                                            print("object");

                                            _mapController
                                                .updateIndividualLocationDetailsField();

                                            locationDetailsBottomSheet(context,
                                                isUpdate: true);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.blue),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // _addController.loadingPositionName.value
                                              //     ? circularButtonIndicator()
                                              //     : const SizedBox(),
                                              SizedBox(width: 20),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6),
                                                child: Text(
                                                  "Update changes",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Center(
                                        child: TextButton(
                                          onPressed: () async {
                                            _mapController.loading.value = true;

                                            _mapController
                                                .showBottomSheet.value = false;
                                            String id = _mapController
                                                .individualLocationDetails
                                                .value
                                                .id!;
                                            await _firebaseController
                                                .deleteLocationDetails(id);

                                            _mapController.allMarker1
                                                .remove(id);

                                            _mapController.loading.value =
                                                false;
                                          },
                                          child: const Text(
                                            "This parking is no longer available!",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 241, 54, 40)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              );
      }),
    );
  }

  // addMarkers(String id, LatLng location) async {
  //   var url = "https://afzalali15.github.io/images/marvin.png";
  //   var bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
  //       .buffer
  //       .asUint8List();

  //   var marker = Marker(
  //     onTap: () {
  //       print("object");
  //     },
  //     markerId: MarkerId(id),
  //     position: location,

  //     infoWindow: const InfoWindow(
  //       title: "Title of place",
  //       snippet: "Description of place",
  //     ),
  //     // icon: BitmapDescriptor.fromBytes(bytes),
  //   );

  //   _mapController.allMarker.add(marker);
  //   setState(() {});
  // }
}
