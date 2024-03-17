import 'package:flutter/material.dart';
import 'package:np_parking/constants/colors.dart';

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

Widget circularButtonIndicator() {
  return const SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
      strokeWidth: 3,
      color: AppColors.white,
    ),
  );
}
