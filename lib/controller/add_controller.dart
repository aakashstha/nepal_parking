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
  List openingDays = [].obs;

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
        ? "| 7/24"
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
      var response = await dio.get(endpoint, queryParameters: queryParameters);
      print(response.data['results'][0]['address_components'][0]["long_name"]);
      placeNameController.text =
          response.data['results'][0]['address_components'][0]["long_name"];
    } catch (e) {
      print(e);
    }
  }

  // Future<dynamic> getEmailSmsNotification() async {
  //   centerLoading.value = true;
  //   String endpoint = "${AppConstants.baseURLProd}v2/notify/status";

  //   Dio dio = Dio();
  //   dio.options.headers = await getHeader();

  //   try {
  //     var response = await dio.get(endpoint);
  //     centerLoading.value = false;
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.toString());
  //       phone.value = data["phone"] == "1" ? true : false;
  //       email.value = data["email"] == "1" ? true : false;

  //       data["away_date"].forEach((element) {
  //         int length = dateAwayScheduleList.length;
  //         // print(element);
  //         dateAwayScheduleList[length.toString()] =
  //             AddDateAwaySchedule(key: length.toString());
  //         dateAwayScheduleList[length.toString()].dateController.text = element;
  //       });

  //       return data["code"];
  //     }
  //   } catch (e) {
  //     centerLoading.value = false;
  //     if (e is DioException) {
  //       if (e.response!.statusCode == 401) {
  //         showTokenExpirePopUpAlert();
  //       }
  //       return e.response!.statusCode;
  //     }
  //   }
  // }
}
