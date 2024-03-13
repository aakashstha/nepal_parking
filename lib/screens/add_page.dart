import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/screens/search.dart';

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
      appBar: AppBar(
        title: const Text("Next, Long press anywhere in the map."),
      ),
      body: currentLocation == null
          ? const Center(child: Text("Loading..."))
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 15,
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Search()),
                      );
                    },
                    child: const Icon(Icons.search),
                  ),
                )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
