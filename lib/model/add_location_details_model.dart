import 'package:cloud_firestore/cloud_firestore.dart';

class AddLocationDetailsModel {
  String? id;
  GeoPoint latlng;
  String placeName;
  List vehicle;
  String charge;
  String locationType;
  List openingDays;
  bool isAllDayOpen;
  String openingTime;
  String closingTime;

  AddLocationDetailsModel({
    this.id,
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
      id: json["id"],
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

    data["id"] = id;
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
