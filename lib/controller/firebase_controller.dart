import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/enum.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/controller/map_controller.dart';
import 'package:np_parking/model/add_location_details_model.dart';
import 'package:np_parking/utilities/converter.dart';

final AddController _addController = Get.put(AddController());
final MapController _mapController = Get.put(MapController());

class FirebaseController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var locationDetailsLenght = 0.obs;

  // Get all Location Details
  Future<void> getAllLocationDetails() async {
    await FirebaseFirestore.instance
        .collection('locationDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _mapController.allLocationDetails.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // convert 24 format time to 12 format
        data["openingTime"] = data["openingTime"].isEmpty
            ? ""
            : convert24To12(data["openingTime"]);
        data["closingTime"] = data["closingTime"].isEmpty
            ? ""
            : convert24To12(data["closingTime"]);

        _mapController.allLocationDetails
            .add(AddLocationDetailsModel.fromJson(data));
      }
    });
  }

  // Add Location Details
  Future<void> addLocationDetails() async {
    String openingTime24Hour = _addController.openingTimeController.text.isEmpty
        ? ""
        : convert12To24(_addController.openingTimeController.text);
    String closingTime24Hour = _addController.closingTimeController.text.isEmpty
        ? ""
        : convert12To24(_addController.closingTimeController.text);

    var a = AddLocationDetailsModel(
      latlng: GeoPoint(
        _addController.latlng.latitude,
        _addController.latlng.longitude,
      ),
      placeName: _addController.placeNameController.text,
      vehicle: _addController.vehicle,
      charge: _addController.charge.value,
      locationType: _addController.locationType.value,
      openingDays: _addController.openingDays,
      isAllDayOpen: _addController.isAllDayOpen.value,
      openingTime: openingTime24Hour,
      closingTime: closingTime24Hour,
    );

    try {
      await _firebaseFirestore.collection('locationDetails').add(a.toJson());
    } catch (e) {
      print("ERROR: + e.message");
    }
  }

// Update Location Details
  Future<void> updateLocationDetails(String id) async {
    String openingTime24Hour = _addController.openingTimeController.text.isEmpty
        ? ""
        : convert12To24(_addController.openingTimeController.text);
    String closingTime24Hour = _addController.closingTimeController.text.isEmpty
        ? ""
        : convert12To24(_addController.closingTimeController.text);

    var a = AddLocationDetailsModel(
      latlng: GeoPoint(
        _mapController.individualLocationDetails.value.latlng.latitude,
        _mapController.individualLocationDetails.value.latlng.longitude,
      ),
      placeName: _addController.placeNameController.text,
      vehicle: _addController.vehicle,
      charge: _addController.charge.value,
      locationType: _addController.locationType.value,
      openingDays: _addController.openingDays,
      isAllDayOpen: _addController.isAllDayOpen.value,
      openingTime: openingTime24Hour,
      closingTime: closingTime24Hour,
    );

    try {
      await _firebaseFirestore
          .collection('locationDetails')
          .doc(id)
          .update(a.toJson());
    } catch (e) {
      print("ERROR: + e.message");
    }
  }

  // Delete Location Details
  Future<void> deleteLocationDetails(String id) async {
    await _firebaseFirestore.collection('locationDetails').doc(id).delete();
  }
}
