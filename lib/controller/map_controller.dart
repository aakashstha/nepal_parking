import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/controller/firebase_controller.dart';
import 'package:np_parking/model/add_location_details_model.dart';
import 'package:np_parking/utilities/converter.dart';

final FirebaseController _firebaseController = Get.put(FirebaseController());

class MapController extends GetxController {
  var loading = false.obs;
  LocationData? currentLocation;
  late GoogleMapController googleMapController;

  List<AddLocationDetailsModel> allLocationDetails = [];
  var showBottomSheet = false.obs;
  var individualLocationDetails = AddLocationDetailsModel(
    id: "",
    latlng: GeoPoint(0, 0),
    placeName: "",
    vehicle: [],
    charge: "",
    locationType: "",
    openingDays: [],
    isAllDayOpen: false,
    openingTime: "",
    closingTime: "",
  ).obs;

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
  }.obs;

  Future<void> addAllLocationMarkerandDetails() async {
    await _firebaseController.getAllLocationDetails();

    // print(allLocationDetails[0].id);
    // print(allLocationDetails.length);

    for (int i = 0; i < allLocationDetails.length; i++) {
      allMarker.add(
        Marker(
          markerId: MarkerId("${allLocationDetails[i].id}"),
          position: LatLng(
            allLocationDetails[i].latlng.latitude,
            allLocationDetails[i].latlng.longitude,
          ),
          onTap: () {
            individualLocationDetails.value = allLocationDetails[i];

            // Reload UI
            individualLocationDetails.refresh();
            showBottomSheet.value = true;
          },
          infoWindow: InfoWindow(
            title: allLocationDetails[i].placeName,
            snippet: "Parking is available",
          ),
        ),
      );
    }
    print(allMarker.length);
  }

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
