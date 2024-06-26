import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/colors.dart';
import 'package:np_parking/constants/constants.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/controller/firebase_controller.dart';
import 'package:np_parking/controller/map_controller.dart';

final FirebaseController _firebaseController = Get.put(FirebaseController());
final AddController _addController = Get.put(AddController());
final MapController _mapController = Get.put(MapController());

Future<void> confirmAlertDialog({bool isUpdate = false}) async {
  return showDialog<void>(
    context: navKey.currentContext!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: isUpdate
            ? const Text(
                'Thank you for your update!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              )
            : const Text(
                'Thank you for adding parking spot!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
        content: const SingleChildScrollView(
          child: Text(
            "Your contribution will benefit both you and others in finding and parking vehicles using this application.",
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const BeveledRectangleBorder(),
                  ),
                  onPressed: () async {
                    if (!isUpdate) {
                      _addController.clearAllAddLocationField();
                    }

                    Get.back();
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Confirm Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const BeveledRectangleBorder(),
                  ),
                  onPressed: () async {
                    _addController.loading.value = true;
                    Get.back();
                    Get.back();

                    if (isUpdate) {
                      _mapController.loading.value = true;

                      await _firebaseController.updateLocationDetails(
                          _mapController.individualLocationDetails.value.id!);
                      _mapController.showBottomSheet.value = false;
                      await _firebaseController.getAllLocationDetails();
                      await _mapController.addAllLocationMarkerandDetails();

                      _mapController.loading.value = false;
                    } else {
                      await _firebaseController.addLocationDetails();
                    }

                    _addController.loading.value = false;
                    _addController.clearAllAddLocationField();
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
