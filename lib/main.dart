import 'package:flutter/material.dart';
import 'package:np_parking/constants/constants.dart';
import 'package:np_parking/screens/home.dart';
import 'package:np_parking/screens/home_page_navigation.dart';
import 'package:np_parking/screens/profile.dart';
import 'package:np_parking/screens/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePageNavigation(),
      // home: Test(),
    );
  }
}
