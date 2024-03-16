import 'package:cloud_firestore/cloud_firestore.dart';

class AddLocationDetailsModel {
  final GeoPoint latlng;
  final String placeName;
  final List vehicle;
  final String charge;
  final String locationType;
  final List openingDays;
  final bool isAllDayOpen;
  final String openingTime;
  final String closingTime;

  const AddLocationDetailsModel({
    required this.latlng,
    required this.placeName,
    required this.vehicle,
    required this.charge,
    required this.locationType,
    required this.openingDays,
    required this.isAllDayOpen,
    required this.openingTime,
    required this.closingTime,
  });

  factory AddLocationDetailsModel.fromJson(Map<String, dynamic> json) {
    return AddLocationDetailsModel(
      latlng: json["latlng"],
      placeName: json["placeName"],
      vehicle: json["vehicle"],
      charge: json["charge"],
      locationType: json["locationType"],
      openingDays: json["openingDay"],
      isAllDayOpen: json["isAllDayOpen"],
      openingTime: json["openingTime"],
      closingTime: json["closingTime"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["latlng"] = latlng;
    data["placeName"] = placeName;
    data["vehicle"] = vehicle;
    data["charge"] = charge;
    data["locationType"] = locationType;
    data["openingDay"] = openingDays;
    data["isAllDayOpen"] = isAllDayOpen;
    data["openingTime"] = openingTime;
    data["closingTime"] = closingTime;
    return data;
  }
}
