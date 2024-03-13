import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _HomeState createState() => _HomeState();
}

/*

Please note that you should not hardcode your API key in the production app. Instead, consider using a secure approach to store and retrieve your API key, such as using environment variables or a configuration file.

*/
class _HomeState extends State<Search> {
  String googleApikey = "AIzaSyDfG85bC15NFqShpDnpGA1BscSx7eGnA9o";
  String location = "Search Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Search Autocomplete Google Map"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            child: InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'np')],
                  onError: (err) {
                    print(err);
                  },
                );

                if (place != null) {
                  var response =
                      await getPlaceDetails(place.placeId!, googleApikey);
                  print(response);

                  setState(() {
                    location = place.description.toString();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        title: Text(
                          location,
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: const Icon(Icons.search),
                        dense: true,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<PlaceDetails> getPlaceDetails(String placeId, String apiKey) async {
  const apiUrl = "https://maps.googleapis.com/maps/api/place/details/json";
  var dio = Dio();

  final response = await dio.get("$apiUrl?place_id=$placeId&key=$apiKey");

  if (response.statusCode == 200) {
    var a = jsonDecode(response.toString());
    print(a["html_attributions"]);
    print(a["result"]["address_components"]);
    print(a["result"]["formatted_address"]);
    print(a["result"]["geometry"]["location"]);
    print(a["result"]["place_id"]);
    print(a["status"]);

    print("");
    return PlaceDetails.fromJson(jsonDecode(response.toString()));
  } else {
    throw Exception("Failed to fetch place details");
  }
}

class PlaceDetails {
  final List htmlAttributions;
  final List<dynamic> addressComponents;
  final String formattedAddress;
  final Map<dynamic, dynamic> geometry;
  final String placeId;
  final String status;

  PlaceDetails({
    required this.htmlAttributions,
    required this.addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.status,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      htmlAttributions: json["html_attributions"],
      addressComponents: json["result"]["address_components"],
      formattedAddress: json["result"]["formatted_address"],
      geometry: json["result"]["geometry"]["location"],
      placeId: json["result"]["place_id"],
      status: json["status"],
    );
  }
}
