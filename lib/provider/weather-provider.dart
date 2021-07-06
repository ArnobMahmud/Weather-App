import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/current-weather-model.dart';
import 'package:weather_app/models/forecast-weather-model.dart';
import 'package:weather_app/config/utils.dart';
import 'package:http/http.dart' as Http;

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse _current;
  ForecastWeatherResponse _forecast;

  CurrentWeatherResponse get getCurrentData => _current;
  ForecastWeatherResponse get getforecastData => _forecast;

  Future fetchCurrentData(Position position) async {
    final url =
        'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$weather_api_key';

    try {
      final response = await Http.get(Uri.parse(url));
      final responseMap = jsonDecode(response.body);
      print(response.body);
      _current = CurrentWeatherResponse.fromJson(responseMap);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future fetchForecastData(Position position) async {
    final url =
        'http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&cnt=90&units=metric&appid=$weather_api_key';

    try {
      final response = await Http.get(Uri.parse(url));
      final responseMap = jsonDecode(response.body);

      _forecast = ForecastWeatherResponse.fromJson(responseMap);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
