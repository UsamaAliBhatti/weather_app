// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);

import 'dart:convert';

CitiesModel citiesModelFromJson(String str) => CitiesModel.fromJson(json.decode(str));

String citiesModelToJson(CitiesModel data) => json.encode(data.toJson());

class CitiesModel {
    List<City> cities;

    CitiesModel({
        required this.cities,
    });

    factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
    };
}

class City {
    String country;
    String name;
    String lat;
    String lng;

    City({
        required this.country,
        required this.name,
        required this.lat,
        required this.lng,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        country: json["country"],
        name: json["name"],
        lat: json["lat"],
        lng: json["lng"],
    );

    Map<String, dynamic> toJson() => {
        "country": country,
        "name": name,
        "lat": lat,
        "lng": lng,
    };
}
