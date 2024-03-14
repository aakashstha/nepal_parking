import 'package:flutter/material.dart';

Widget circularProgressIndicator() {
  return const SizedBox(
    height: 40,
    width: 40,
    child: CircularProgressIndicator(
      strokeWidth: 3,
      color: Colors.blue,
    ),
  );
}
