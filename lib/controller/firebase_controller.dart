import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Get all Location Details
  Stream<QuerySnapshot> collectionStream() =>
      FirebaseFirestore.instance.collection('locationDetails').snapshots();

  // Add Location Details
  Future<void> addLocation(double lat, double lng) async {
    Map<String, dynamic> locationDetails = {
      "latlng": GeoPoint(lat, lng),
      "placeName": "bhaktapur",
      "vehicle": "car",
      "charge": "paid",
      "locationType": "hospital",
      "openingDay": "everyday",
      "openingTime": "24/7",
    };
    try {
      await _firebaseFirestore
          .collection('locationDetails')
          .add(locationDetails);
    } catch (e) {
      print("ERROR: + e.message");
    }
  }
}
