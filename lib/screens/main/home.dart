import 'dart:async';

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
  final MapController _mapController = Get.put(MapController());
  final FirebaseController _firebaseController = Get.put(FirebaseController());

  @override
  void initState() {
    if (_mapController.currentLocation == null) {
      _mapController.getCurrentLocation();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => _mapController.loading.value
            ? Center(child: circularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    padding: const EdgeInsets.only(top: 110.0),
                    onMapCreated: (controller) {
                      _mapController.googleMapController = controller;
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
                    markers: _mapController.allMarker,
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
                        _firebaseController.collectionStream();
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
                    bottom: 80,
                    right: -5,
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {});
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

                  //
                  //
                  //
                  //
                  Align(
                    alignment: const Alignment(0, 0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firebaseController.collectionStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        var docs = snapshot.data!.docs;
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                        var a = docs[0].data() as Map;
                        print(a['latlng'].latitude);
                        print(a['latlng'].longitude);
                        print(docs.length);

                        for (int i = 0; i < docs.length; i++) {
                          var a = docs[i].data() as Map;
                          _mapController.allMarker.add(
                            Marker(
                              markerId: MarkerId("$i"),
                              position: LatLng(
                                  a['latlng'].latitude, a['latlng'].longitude),
                            ),
                          );
                        }

                        // _mapController.allMarker.add(
                        //   Marker(
                        //     markerId: MarkerId("${docs.length}"),
                        //     position: LatLng(
                        //         a['latlng'].latitude, a['latlng'].longitude),
                        //   ),
                        // );

                        // return docs.isEmpty
                        //     ? const Text("No message yet.")
                        //     : ListView.builder(
                        //         itemCount: docs.length,
                        //         itemBuilder: (context, index) {
                        //           var data = docs[index].data() as Map;
                        //           return ListTile(
                        //             title: Text(data['latlng'].toString()),
                        //           );
                        //         },
                        //       );
                        return Text("hey");
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  addMarkers(String id, LatLng location) async {
    var url = "https://afzalali15.github.io/images/marvin.png";
    var bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();

    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(
        title: "Title of place",
        snippet: "Description of place",
      ),
      // icon: BitmapDescriptor.fromBytes(bytes),
    );

    _mapController.allMarker.add(marker);
    setState(() {});
  }
}
