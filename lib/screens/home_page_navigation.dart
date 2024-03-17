import 'package:flutter/material.dart';
import 'package:np_parking/constants/colors.dart';
import 'package:np_parking/screens/main/add_location.dart';
import 'package:np_parking/screens/main/home.dart';
import 'package:np_parking/screens/main/profile.dart';

class HomePageNavigation extends StatefulWidget {
  final int selectedIndex;
  const HomePageNavigation({this.selectedIndex = 0, super.key});

  @override
  HomePageNavigationState createState() => HomePageNavigationState();
}

class HomePageNavigationState extends State<HomePageNavigation> {
  int _selectedIndex = 0;
  final _pageOptions = <Widget>[HomePage(), const AddPage(), const Profile()];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    // _selectedIndex = widget.selectedIndex;
    _pageOptions.addAll([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            //canvasColor: Colors.green,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(bodySmall: const TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 227, 227, 227),
          elevation: 4,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryBlue,
          selectedIconTheme: const IconThemeData(color: AppColors.primaryBlue),
          unselectedIconTheme: const IconThemeData(color: Colors.black),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.zoom_in),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
