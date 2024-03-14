import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/screens/search.dart';
import 'package:np_parking/widgets/circular_indicator.dart';

const LatLng currentLocation1 = LatLng(27.679213, 85.398276);

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final AddController _addController = Get.put(AddController());
  static const LatLng destinationLocation = LatLng(27.678602, 85.405090);

  Map<String, Marker> allMarker = {
    "0": const Marker(
      markerId: MarkerId("0"),
      position: destinationLocation,
    ),
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
        appBar: AppBar(
          title: const Text("Next, Long press anywhere in the map."),
        ),
        body: Obx(
          () => _addController.loading.value
              ? Center(child: circularProgressIndicator())
              : Stack(
                  children: [
                    GoogleMap(
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
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      compassEnabled: false,
                      markers: allMarker.values.toSet(),

                      onLongPress: (taplatlng) async {
                        geolocator.Position currentPosition =
                            await geolocator.Geolocator.getCurrentPosition(
                                desiredAccuracy:
                                    geolocator.LocationAccuracy.best);

                        print(allMarker.length);
                        print(taplatlng.latitude);
                        print(taplatlng.longitude);

                        allMarker.addAll({
                          "${allMarker.length}": Marker(
                            markerId: MarkerId("${allMarker.length}"),
                            position:
                                LatLng(taplatlng.latitude, taplatlng.longitude),
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
                  ],
                ),
        ));
  }
}
