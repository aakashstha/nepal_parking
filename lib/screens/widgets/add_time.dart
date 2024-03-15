import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/colors.dart';
import 'package:np_parking/constants/constants.dart';
import 'package:intl/intl.dart';

class AddDateTime {
  TextEditingController openingTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();

  AddDateTime();

  Widget addDateTime() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Opening Time",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: openingTimeController,
            validator: (val) {
              // return Validator.validateEmpty(val!, "Start Time");
            },
            decoration: const InputDecoration(
              hintText: "--:-- --",
              prefix: SizedBox(width: 5),
              suffixIcon: Icon(Icons.access_time),
            ),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              print(pickedTime);
              if (pickedTime != null) {
                // print(
                //     "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                openingTimeController.text =
                    pickedTime.format(context); //output 10:51 PM
              } else {
                log("Time is not selected");
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Closing Time",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: closingTimeController,
            // validator: (val) {
            //   // return Validator.validateEmpty(val!, "End Time");
            // },
            decoration: const InputDecoration(
              hintText: "--:-- --",
              prefix: SizedBox(width: 5),
              suffixIcon: Icon(Icons.access_time),
            ),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              print(pickedTime);
              if (pickedTime != null) {
                // print(
                //     "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                closingTimeController.text =
                    pickedTime.format(context); //output 10:51 PM
              } else {
                log("Time is not selected");
              }
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
