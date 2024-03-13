import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var loading = false.obs;
  var centerLoading = false.obs;
  var phone = false.obs;
  var email = false.obs;
  var dataLoaded = false.obs;
  var dateAwayScheduleList = {}.obs;

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
