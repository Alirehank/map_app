// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<LocationData> welcomeFromJson(String str) => List<LocationData>.from(json.decode(str).map((x) => LocationData.fromJson(x)));

String welcomeToJson(List<LocationData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationData {
    int id;
    String name;
    double latitude;
    double longitude;
    String city;
    String email;

    LocationData({
        required this.id,
        required this.name,
        required this.latitude,
        required this.longitude,
        required this.city,
        required this.email,
    });

    factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        city: json["city"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "city": city,
        "email": email,
    };
}
