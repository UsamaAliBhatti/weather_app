import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/api_handler/api_handler.dart';
import 'package:weather_app/models/citie_model.dart' as city;
import 'package:weather_app/models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  //variables
  var controller = TextEditingController();
  city.CitiesModel? _citiesModel;
  String? _cityName;
  double? _latitude;
  double? _longitude;
  city.City? _selectedCity;
  WeatherModel? _weatherModel;
  bool _isLoading = true;

  //getter methods
  get latitude => _latitude;
  get getLoading => _isLoading;

  get longitude => _longitude;
  WeatherModel? get weatherModel => _weatherModel;

  String? get getCityName => _cityName;

  city.CitiesModel? get citiesModel => _citiesModel;

  city.City? get selectedCity => _selectedCity;

  setSearchLocation(String name) {
    _cityName = name;
    notifyListeners();
  }

  fetchWeatherForecast() async {
    _isLoading = true;
    _weatherModel =
        await ApiHandler.fetchWeatherForcast(_cityName!).whenComplete(() {
      _isLoading = false;
    });

    notifyListeners();
  }

  //methods
  loadData() {
    getCitiesFromJson();
    getCurrentLocation().then((value) => fetchWeatherForecast());
  }

  getCitiesFromJson() async {
    final jsonData = await rootBundle.loadString('assets/cities.json');

    _citiesModel = city.citiesModelFromJson(jsonData);

    notifyListeners();
  }

  setLocation(double glatitude, double glongitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        glatitude,
        glongitude,
      );
      _cityName = placemarks[0].locality;

      _latitude = glatitude;
      _longitude = glongitude;
      notifyListeners();
      print('$_longitude $_latitude');
    } on Exception {
      // TODO
    }
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      Geolocator.openLocationSettings();
      return;
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await setLocation(position.latitude, position.longitude);
      /*  try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        _cityName = placemarks[0].locality;

        _latitude = position.latitude;
        _longitude = position.longitude;
        print('$_longitude $_latitude');
      } catch (err) {
        debugPrint(err.toString());
      } */
    }

    notifyListeners();
    // print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
