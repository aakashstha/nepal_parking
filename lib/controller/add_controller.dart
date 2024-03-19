import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:np_parking/constants/enum.dart';

class AddController extends GetxController {
  var loading = false.obs;
  var loadingPositionName = false.obs;
  LocationData? currentLocation;
  late GoogleMapController googleMapController;
  var googleMaptype = MapType.normal.obs;
  var latlng;

  TextEditingController placeNameController = TextEditingController();
  var vehicle = [].obs;
  var charge = Charge.paid.name.obs;
  var locationType = LocationType.public.name.obs;
  TextEditingController locationTypeController = TextEditingController();
  // Opening Day
  var isEverydayChecked = false.obs;
  var openingDays = [].obs;

  // Opening/Closing Time
  TextEditingController dayTimeController = TextEditingController();
  var isAllDayOpen = false.obs;
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  // For showing in Day/Time Field
  void addInDayTimeTextField() {
    String days =
        openingDays.map((day) => day.substring(0, 3)).toList().join(", ");

    String time = isAllDayOpen.value
        ? "| 24 hours"
        : "| ${openingTimeController.text} | ${closingTimeController.text}";

    dayTimeController.text = "$days  $time";
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

  Future<void> fetchRealAddress() async {
    String endpoint = "https://maps.googleapis.com/maps/api/geocode/json";
    Dio dio = Dio();
    final queryParameters = {
      'latlng': "${latlng.latitude},${latlng.longitude}",
      'result_type': 'locality',
      'key': 'AIzaSyDfG85bC15NFqShpDnpGA1BscSx7eGnA9o'
    };

    try {
      loadingPositionName.value = true;
      var response = await dio.get(endpoint, queryParameters: queryParameters);
      placeNameController.text =
          response.data['results'][0]['address_components'][0]["long_name"];

      loadingPositionName.value = false;
    } catch (e) {
      print(e);
    }
  }

  void clearAllAddLocationField() {
    placeNameController.clear();
    vehicle.clear();
    charge.value = Charge.paid.name;
    locationType.value = LocationType.public.name;
    openingDays.clear();
    isEverydayChecked.value = false;
    isAllDayOpen.value = false;
    openingTimeController.clear();
    closingTimeController.clear();
    dayTimeController.clear();
  }
}
