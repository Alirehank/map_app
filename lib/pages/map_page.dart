import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:map_with_api/model.dart';

class GoogleDashboard extends StatefulWidget {
  const GoogleDashboard({super.key});

  @override
  State<GoogleDashboard> createState() => _GoogleDashboardState();
}

class _GoogleDashboardState extends State<GoogleDashboard> {
  List<LocationData> allMarkers = [];
  List<LocationData> filteredMarkers = [];
  bool isLoading = true;
  String selectedCity = "All";

  Future<void> fetchMarkers() async {
    final response = await http.get(
      Uri.parse('https://4a692014c6bc.ngrok-free.app/api/test'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      setState(() {
        allMarkers = data.map((item) => LocationData.fromJson(item)).toList();
        filteredMarkers = allMarkers; // show all initially
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load markers');
    }
  }

  void filterByCity(String city) {
    setState(() {
      selectedCity = city;
      if (city == "All") {
        filteredMarkers = allMarkers;
      } else {
        filteredMarkers = allMarkers
            .where((m) => m.city.toLowerCase() == city.toLowerCase())
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Map with City Filter')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Dropdown or Buttons for city filter
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedCity,
                      items: ["All", "Lahore", "Karachi", "Islamabad"]
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) filterByCity(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(30.0, 70.0),
                        zoom: 5.5,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.myapp',
                        ),
                        MarkerLayer(
                          markers: filteredMarkers.map((loc) {
                            return Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(loc.latitude, loc.longitude),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

