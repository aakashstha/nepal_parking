import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapController extends GetxController {
  var loading = false.obs;
  LocationData? currentLocation;
  late GoogleMapController googleMapController;

  static const LatLng sourceLocation = LatLng(27.678602, 85.405090);
  static const LatLng destinationLocation =
      LatLng(27.682763573554837, 85.39068784564732);
  static const LatLng destinationLocation2 =
      LatLng(27.684208567617446, 85.397270321846);
  Set<Marker> allMarker = {
    const Marker(
      markerId: MarkerId("source"),
      position: sourceLocation,
    ),
    const Marker(
      markerId: MarkerId("destination"),
      position: destinationLocation,
    ),
    const Marker(
      markerId: MarkerId("destination2"),
      position: destinationLocation2,
    ),
  };

  void getCurrentLocation() async {
    loading.value = true;
    LocationPermission permission = await Geolocator.checkPermission();

    // (LocationPermission.denied) is for ios at first time
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      loading.value = false;
    });
  }

  void moveCameraToNewPosition(double lat, double lng) {
    // LatLng newlatlang = LatLng(27.68452149374933, 85.38195859640837);
    LatLng newlatlang = LatLng(lat, lng);

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newlatlang,
          zoom: 13,
        ),
      ),
    );
  }
}
