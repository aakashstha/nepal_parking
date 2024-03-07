import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const LatLng currentLocation1 = LatLng(27.679213, 85.398276);

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(27.678602, 85.405090);
  static const LatLng destinationLocation = LatLng(27.683157, 85.384274);

  Map<String, Marker> allMarker = {
    "0": const Marker(
      markerId: MarkerId("0"),
      position: sourceLocation,
    ),
  };

  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      print(location);
      setState(() {});
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      print(newLoc);

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        zoom: 13.5,
        target: LatLng(
          newLoc.latitude!,
          newLoc.longitude!,
        ),
      )));
      setState(() {});
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: currentLocation1,
                zoom: 14,
              ),
              myLocationEnabled: true,
              markers: allMarker.values.toSet(),
              // markers: {
              //   const Marker(
              //     markerId: MarkerId("destination"),
              //     position: destinationLocation,
              //   ),
              // },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          geolocator.Position currentPosition =
              await geolocator.Geolocator.getCurrentPosition(
                  desiredAccuracy: geolocator.LocationAccuracy.best);

          print(allMarker.length);
          print(currentPosition.latitude);
          print(currentPosition.longitude);

          allMarker.addAll({
            "${allMarker.length}": Marker(
              markerId: MarkerId("${allMarker.length}"),
              position:
                  LatLng(currentPosition.latitude, currentPosition.longitude),
            )
          });
          setState(() {});
        },
      ),
    );
  }
}
