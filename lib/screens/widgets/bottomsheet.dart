import 'package:flutter/material.dart';
import 'package:np_parking/constants/constants.dart';
import 'package:np_parking/screens/widgets/add_time.dart';

void locationTypeBottomSheet() {
  showModalBottomSheet<void>(
    context: navKey.currentContext!,
    builder: (BuildContext context) {
      return SizedBox(
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
                  5,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Public"),
                                Icon(Icons.check),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ))
            ],
          ),
        ),
      );
    },
  );
}

void openingDayTimeBottomSheet() {
  showModalBottomSheet<void>(
    context: navKey.currentContext!,
    builder: (BuildContext context) {
      return SizedBox(
        height: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Text(
                  "Opening Day/Time",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
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
                  Text(
                    "Everyday",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                ],
              ),
              ...List.generate(
                7,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sunday"),
                          Icon(Icons.check),
                        ],
                      ),
                      Divider()
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
                    "Open 7 /24",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                ],
              ),
              AddDateTime().addDateTime()
            ],
          ),
        ),
      );
    },
  );
}
