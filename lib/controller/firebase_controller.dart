import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/enum.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/model/add_location_details_model.dart';
import 'package:np_parking/utilities/converter.dart';

final AddController _addController = Get.put(AddController());

class FirebaseController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Get all Location Details
  Stream<QuerySnapshot> collectionStream() =>
      FirebaseFirestore.instance.collection('locationDetails').snapshots();

  // Add Location Details
  Future<void> addLocationDetails() async {
    String openingTime24Hour = _addController.openingTimeController.text.isEmpty
        ? "00:00"
        : convert12To24(_addController.openingTimeController.text);
    String closingTime24Hour = _addController.closingTimeController.text.isEmpty
        ? "00:00"
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
}
