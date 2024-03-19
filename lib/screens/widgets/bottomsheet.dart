import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:np_parking/constants/constants.dart';
import 'package:np_parking/constants/enum.dart';
import 'package:np_parking/controller/add_controller.dart';
import 'package:np_parking/screens/widgets/add_time.dart';

final AddController _addController = Get.put(AddController());
void locationTypeBottomSheet() {
  showModalBottomSheet<void>(
    backgroundColor: Colors.white,
    context: navKey.currentContext!,
    builder: (BuildContext context) {
      return Obx(
        () => SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                    "Location Type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ...List.generate(
                    LocationType.values.length,
                    (index) => InkWell(
                          onTap: () {
                            _addController.locationType.value =
                                LocationType.values[index].name;

                            _addController.locationTypeController.text =
                                _addController
                                    .locationType.value.capitalizeFirst!;

                            Get.back();
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocationType
                                          .values[index].name.capitalizeFirst!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    LocationType.values[index].name ==
                                            _addController.locationType.value
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.blue,
                                          )
                                        : const SizedBox(height: 24)
                                  ],
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(
                                    Size(double.infinity, 1)),
                                child: Divider(),
                              )
                            ],
                          ),
                        ))
              ],
            ),
          ),
        ),
      );
    },
  );
}

void openingDayTimeBottomSheet() {
  showModalBottomSheet<void>(
    backgroundColor: Colors.white,
    context: navKey.currentContext!,
    builder: (BuildContext context) {
      return Obx(
        () => SizedBox(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ListView(
              children: <Widget>[
                const Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Text(
                    "Opening Day/Time",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Center(
                  child: Text(
                    "Day",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Everyday",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Checkbox(
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      value: _addController.isEverydayChecked.value,
                      onChanged: (value) {
                        _addController.isEverydayChecked.value = value!;

                        if (value) {
                          _addController.openingDays.clear();
                          for (var i = 0; i < OpeningDay.values.length; i++) {
                            _addController.openingDays
                                .add(OpeningDay.values[i].name);
                          }
                          print(_addController.openingDays);
                        } else {
                          _addController.openingDays.clear();
                          print(_addController.openingDays);
                        }

                        // add in DayTime TextField
                        _addController.addInDayTimeTextField();
                      },
                    ),
                  ],
                ),
                ...List.generate(
                  OpeningDay.values.length,
                  (index) => InkWell(
                    onTap: () {
                      _addController.openingDays
                              .contains(OpeningDay.values[index].name)
                          ? _addController.openingDays
                              .remove(OpeningDay.values[index].name)
                          : _addController.openingDays
                              .add(OpeningDay.values[index].name);

                      // if all days are checked then uncheck everyday
                      if (_addController.openingDays.length == 7) {
                        _addController.isEverydayChecked.value = true;
                      } else {
                        _addController.isEverydayChecked.value = false;
                      }
                      // add in DayTime TextField
                      _addController.addInDayTimeTextField();
                      print(_addController.openingDays);

                      _addController.openingDays;
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                OpeningDay.values[index].name.capitalizeFirst!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _addController.openingDays
                                      .contains(OpeningDay.values[index].name)
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                    )
                                  : const SizedBox(height: 24)
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tight(Size(double.infinity, 1)),
                          child: Divider(),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    "Time",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Open 24 hours",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Checkbox(
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      value: _addController.isAllDayOpen.value,
                      onChanged: (value) {
                        _addController.isAllDayOpen.value = value!;
                        _addController.addInDayTimeTextField();

                        _addController.openingTimeController.text = "";
                        _addController.closingTimeController.text = "";
                      },
                    ),
                  ],
                ),
                AddDateTime().addDateTime()
              ],
            ),
          ),
        ),
      );
    },
  );
}
