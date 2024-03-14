import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/controller/map_controller.dart';
import 'package:np_parking/screens/search.dart';
import 'package:get/get.dart';
import 'package:np_parking/widgets/circular_indicator.dart';

class HomePage extends StatefulWidget {
  bool isSearch;
  HomePage({super.key, this.isSearch = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = Get.put(MapController());
  static const LatLng sourceLocation = LatLng(27.678602, 85.405090);
  static const LatLng destinationLocation = LatLng(27.683157, 85.384274);

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
