import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/enum.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/controller/firebase_controller.dart';
import 'package:np_parking/screens/widgets/add_time.dart';
import 'package:np_parking/screens/widgets/alert_dialog.dart';
import 'package:np_parking/screens/widgets/bottomsheet.dart';

final AddController _addController = Get.put(AddController());
final FirebaseController _firebaseController = Get.put(FirebaseController());

void locationDetailsBottomSheet(BuildContext context) {
  _addController.locationTypeController.text =
      _addController.locationType.value.capitalizeFirst!;
  showModalBottomSheet<void>(
    backgroundColor: Colors.white,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Obx(
        () => SizedBox(
          height: 700,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Place Name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _addController.placeNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        prefix: SizedBox(width: 10),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        hintText: "Place Name",
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 2, color: Colors.blue),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Place Details",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Wrap(
                        spacing: 10,
                        children: [
                          ...List.generate(
                            Vehicle.values.length,
                            (index) => Stack(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    _addController.vehicle.contains(
                                            Vehicle.values[index].name)
                                        ? _addController.vehicle
                                            .remove(Vehicle.values[index].name)
                                        : _addController.vehicle
                                            .add(Vehicle.values[index].name);

                                    print(_addController.vehicle);
                                  },
                                  child: Container(
                                    width: 165,
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _addController.vehicle.contains(
                                                Vehicle.values[index].name)
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        vehicleNameIcon.values.toList()[index],
                                        Text(
                                          vehicleNameIcon.keys.toList()[index],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: _addController.vehicle
                                            .contains(
                                                Vehicle.values[index].name)
                                        ? Colors.blue
                                        : Colors.grey,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Icon(
                                          color: _addController.vehicle
                                                  .contains(Vehicle
                                                      .values[index].name)
                                              ? Colors.blue
                                              : Colors.grey,
                                          Icons.check,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Wrap(
                        spacing: 10,
                        children: [
                          ...List.generate(
                            Charge.values.length,
                            (index) => Stack(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (Charge.values[index].name ==
                                        Charge.paid.name) {
                                      _addController.charge.value =
                                          Charge.paid.name;
                                    } else {
                                      _addController.charge.value =
                                          Charge.free.name;
                                    }

                                    print(_addController.charge);
                                  },
                                  child: Container(
                                    width: 165,
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Charge.values[index].name ==
                                                _addController.charge.value
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            Charge.values
                                                .toList()[index]
                                                .name
                                                .toString()
                                                .capitalizeFirst!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        Charge.values[index].name ==
                                                _addController.charge.value
                                            ? Colors.blue
                                            : Colors.grey,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Icon(
                                          color: Charge.values[index].name ==
                                                  _addController.charge.value
                                              ? Colors.blue
                                              : Colors.grey,
                                          Icons.check,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Location Type",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _addController.locationTypeController,
                        onTap: () {
                          // print(_addController.locationType);
                          locationTypeBottomSheet();
                        },
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          prefix: SizedBox(width: 10),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          hintText: "Type",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Opening Day/Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _addController.dayTimeController,
                        onTap: () {
                          openingDayTimeBottomSheet();
                        },
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          prefix: SizedBox(width: 10),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          hintText: "Day/Time",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(width: 2, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    // Confirm button
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 10),
                      child: TextButton(
                        onPressed: () {
                          confirmAlertDialog();
                          // _firebaseController.addLocationDetails();

                          // Get.back();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
