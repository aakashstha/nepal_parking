import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/controller/map_controller.dart';
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
                    padding: const EdgeInsets.only(top: 50.0),
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
                    top: 50,
                    right: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Search()),
                        );
                      },
                      child: const Icon(Icons.search),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    right: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        LatLng newlatlang =
                            LatLng(27.68452149374933, 85.38195859640837);

                        _mapController.googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 14)
                              //17 is new zoom level
                              ),
                        );
                        //move position of map camera to new location
                      },
                      child: const Icon(Icons.add),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
