import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  static const LatLng sourceLocation = LatLng(27.678602, 85.405090);
  static const LatLng destinationLocation =
      LatLng(27.682763573554837, 85.39068784564732);
  static const LatLng destinationLocation2 =
      LatLng(27.684208567617446, 85.397270321846);

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
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_mapController.currentLocation!.latitude!,
                          _mapController.currentLocation!.longitude!),
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    markers: {
                      const Marker(
                        markerId: MarkerId("source"),
                        position: sourceLocation,
                      ),
                      const Marker(
                        markerId: MarkerId("destination"),
                        position: destinationLocation,
                      ),
                      const Marker(
                        markerId: MarkerId("destination"),
                        position: destinationLocation2,
                      ),
                    },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllList(),
                          ),
                        );
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
                ],
              ),
      ),
    );
  }
}
