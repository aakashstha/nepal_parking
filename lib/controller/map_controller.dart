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
import 'package:np_parking/constants/enum.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/controller/firebase_controller.dart';
import 'package:np_parking/model/add_location_details_model.dart';
import 'package:np_parking/utilities/converter.dart';

final FirebaseController _firebaseController = Get.put(FirebaseController());
final AddController _addController = Get.put(AddController());

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
  var allMarker = <Marker>{}.toSet().obs;
  var allMarker1 = <String, Marker>{}.obs;

  Future<void> addAllLocationMarkerandDetails() async {
    await _firebaseController.getAllLocationDetails();

    // print(allLocationDetails[0].id);
    // print(allLocationDetails.length);

    for (int i = 0; i < allLocationDetails.length; i++) {
      allMarker1["${allLocationDetails[i].id}"] = Marker(
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
          snippet: "Parking spot",
        ),
      );
    }
    print(allMarker.length);
  }

  // Future<void> addAllLocationMarkerandDetails() async {
  //   await _firebaseController.getAllLocationDetails();

  //   // print(allLocationDetails[0].id);
  //   // print(allLocationDetails.length);

  //   for (int i = 0; i < allLocationDetails.length; i++) {
  //     allMarker.add(
  //       Marker(
  //         markerId: MarkerId("${allLocationDetails[i].id}"),
  //         position: LatLng(
  //           allLocationDetails[i].latlng.latitude,
  //           allLocationDetails[i].latlng.longitude,
  //         ),
  //         onTap: () {
  //           individualLocationDetails.value = allLocationDetails[i];

  //           // Reload UI
  //           individualLocationDetails.refresh();
  //           showBottomSheet.value = true;
  //         },
  //         infoWindow: InfoWindow(
  //           title: allLocationDetails[i].placeName,
  //           snippet: "Parking spot",
  //         ),
  //       ),
  //     );
  //   }
  //   print(allMarker.length);
  // }

  void updateIndividualLocationDetailsField() {
    _addController.placeNameController.text =
        individualLocationDetails.value.placeName;
    _addController.vehicle.value = individualLocationDetails.value.vehicle;
    _addController.charge.value = individualLocationDetails.value.charge;
    _addController.locationType.value =
        individualLocationDetails.value.locationType;
    _addController.openingDays.value =
        individualLocationDetails.value.openingDays;
    if (individualLocationDetails.value.openingDays.length == 7) {
      _addController.isEverydayChecked.value = true;
    }
    _addController.isAllDayOpen.value =
        individualLocationDetails.value.isAllDayOpen;
    _addController.openingTimeController.text =
        individualLocationDetails.value.openingTime;
    _addController.closingTimeController.text =
        individualLocationDetails.value.closingTime;

    addInDayTimeTextField();
  }

  // For showing in Day/Time Field
  void addInDayTimeTextField() {
    String days = individualLocationDetails.value.openingDays
        .map((day) => day.substring(0, 3))
        .toList()
        .join(", ");

    String time = _addController.isAllDayOpen.value
        ? "| 24 hours"
        : "| ${individualLocationDetails.value.openingTime} | ${individualLocationDetails.value.closingTime}";

    _addController.dayTimeController.text = "$days  $time";
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
