import 'package:flutter/material.dart';

enum Vehicle { car, twowheeler }

Map<String, Widget> vehicleNameIcon = {
  "Car": const Icon(
    Icons.directions_car,
    size: 60,
  ),
  "Two-wheeler": const Icon(
    Icons.two_wheeler,
    size: 60,
  )
};

enum Charge { free, paid }

enum LocationType { public, hospital, restaurant, bar, store }

enum OpeningDay {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday
}
