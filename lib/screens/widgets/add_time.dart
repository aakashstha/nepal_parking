import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/colors.dart';
import 'package:np_parking/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:np_parking/controller/add_controller.dart';

final AddController _addController = Get.put(AddController());

class AddDateTime {
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
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            enabled: _addController.isAllDayOpen.value ? false : true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _addController.openingTimeController,
            validator: (val) {
              // return Validator.validateEmpty(val!, "Start Time");
            },
            decoration: const InputDecoration(
              hintText: "--:-- --",
              prefix: SizedBox(width: 5),
              suffixIcon: Icon(Icons.access_time),
            ),
            style: _addController.isAllDayOpen.value
                ? null
                : const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                _addController.openingTimeController.text =
                    pickedTime.format(context); //output 10:51 PM
              } else {
                log("Time is not selected");
              }

              _addController.addInDayTimeTextField();
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Closing Time",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            enabled: _addController.isAllDayOpen.value ? false : true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _addController.closingTimeController,
            // validator: (val) {
            //   // return Validator.validateEmpty(val!, "End Time");
            // },
            decoration: const InputDecoration(
              hintText: "--:-- --",
              prefix: SizedBox(width: 5),
              suffixIcon: Icon(Icons.access_time),
            ),
            style: _addController.isAllDayOpen.value
                ? null
                : const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            readOnly: true,
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                _addController.closingTimeController.text =
                    pickedTime.format(context);
              } else {
                log("Time is not selected");
              }
              _addController.addInDayTimeTextField();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
