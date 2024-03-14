import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddController extends GetxController {
  var loading = false.obs;
  LocationData? currentLocation;
  late GoogleMapController googleMapController;

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
