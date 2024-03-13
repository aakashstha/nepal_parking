// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// const LatLng currentLocation1 = LatLng(27.679213, 85.398276);

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late GoogleMapController mapController;
//   Map<String, Marker> _markers = {};

//   final Completer<GoogleMapController> _controller = Completer();
//   static const LatLng sourceLocation = LatLng(27.678602, 85.405090);
//   static const LatLng destinationLocation = LatLng(27.683157, 85.384274);

//   List<LatLng> polyLineCordinates = [];
//   LocationData? currentLocation;

//   void getCurrentLocation() async {
//     Location location = Location();

//     location.getLocation().then((location) {
//       currentLocation = location;
//     });

//     GoogleMapController googleMapController = await _controller.future;

//     location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;

//       googleMapController
//           .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         zoom: 13.5,
//         target: LatLng(
//           newLoc.latitude!,
//           newLoc.longitude!,
//         ),
//       )));
//       setState(() {});
//     });
//   }

//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyDfG85bC15NFqShpDnpGA1BscSx7eGnA9o",
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       result.points.forEach(
//         (PointLatLng point) {
//           polyLineCordinates.add(
//             LatLng(point.latitude, point.longitude),
//           );
//         },
//       );

//       setState(() {});
//     }
//   }

//   Future<void> getCurrentLocationText() async {
//     LocationPermission permission = await Geolocator.checkPermission();

//     // (LocationPermission.denied) is for ios at first time
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       await Geolocator.requestPermission();
//     }
//     // Position currentPosition = await Geolocator.getCurrentPosition(
//     //     desiredAccuracy: LocationAccuracy.best);
//     // var lat = "${currentPosition.latitude}";
//     // var long = "${currentPosition.longitude}";

//     // get address from using google API
//     // await fetchRealAddress();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getCurrentLocationText();
//     getCurrentLocation();
//     getPolyPoints();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: currentLocation == null
//             ? const Center(child: Text("Loading..."))
//             : GoogleMap(
//                 initialCameraPosition: const CameraPosition(
//                   target: currentLocation1,
//                   zoom: 14,
//                 ),
//                 // onMapCreated: (controller) {
//                 //   mapController = controller;
//                 //   addMarkers("test", currentLocation);
//                 // },
//                 // markers: _markers.values.toSet(),
//                 myLocationEnabled: true,
//                 polylines: {
//                   Polyline(
//                     polylineId: PolylineId("route"),
//                     points: polyLineCordinates,
//                     color: Colors.lightBlue,
//                     width: 6,
//                   )
//                 },
//                 markers: {
//                   Marker(
//                     markerId: MarkerId("currentLocation"),
//                     position: LatLng(currentLocation!.latitude!,
//                         currentLocation!.longitude!),
//                   ),
//                   const Marker(
//                     markerId: MarkerId("source"),
//                     position: sourceLocation,
//                   ),
//                   const Marker(
//                     markerId: MarkerId("destination"),
//                     position: destinationLocation,
//                   ),
//                 },
//                 // onMapCreated: (mapController) {
//                 //   _controller.complete(mapController);
//                 // },
//               ),
//       ),
//     );
//   }

//   // addMarkers(String id, LatLng location) async {
//   //   var url = "https://afzalali15.github.io/images/marvin.png";
//   //   var bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
//   //       .buffer
//   //       .asUint8List();

//   //   var marker = Marker(
//   //     markerId: MarkerId(id),
//   //     position: location,
//   //     infoWindow: const InfoWindow(
//   //       title: "Title of place",
//   //       snippet: "Description of place",
//   //     ),
//   //     icon: BitmapDescriptor.fromBytes(bytes),
//   //   );

//   //   _markers[id] = marker;
//   //   setState(() {});
//   // }
// }
