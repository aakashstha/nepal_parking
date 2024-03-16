import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Align(
              child: Container(
                padding: EdgeInsetsDirectional.only(top: 60, bottom: 40),
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('./assets/profile_pic.JPG'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    "Aakash Shrestha",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    "aakash@gmail.com",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.location_pin),
                  SizedBox(width: 10),
                  Text(
                    "Address",
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    "RadheRadhe",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, bottom: 40),
              child: Divider(),
            ),

            // Logout Button
            TextButton(
              onPressed: () async {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromARGB(255, 233, 233, 233),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
