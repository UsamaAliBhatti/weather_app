import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/res/app_url.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<WeatherModel?> fetchWeatherForcast(
    String location,
  ) async {
    var response = await http.post(Uri.parse(AppUrl.forecastApi), body: {
      'q': location,
      'key': AppUrl.apiKey,
      'days': '5',
      'aqi': 'no',
      'alerts': 'no'
    }).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );

    switch (response.statusCode) {
      case 200:
        return weatherModelFromJson(response.body);
      case 404:
        Fluttertoast.showToast(msg: 'Error Occured. Try Again Later');
        return null;
      case 408:
        Fluttertoast.showToast(msg: 'Request Timedout');
        return null;

      case 500:
        Fluttertoast.showToast(msg: 'Server Error: Server did not respond');
        return null;
      default:
        Fluttertoast.showToast(msg: 'Invalid Request');
        return null;
    }
  }
}
