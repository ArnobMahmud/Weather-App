import 'package:flutter/material.dart';
import 'package:weather_app/config/utils.dart';
import 'package:weather_app/models/forecast-weather-model.dart';

class ForecastList extends StatelessWidget {
  final ForecastElement forecastElement;

  const ForecastList({Key key, this.forecastElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9.0),
      child: Column(
        children: [
          Text(
            getFormattedDate(forecastElement.dt, 'EEE'),
            style: TextStyle(fontSize: 20.0),
          ),
          Image.network(
            '$WEATHER_ICON_PREFIX${forecastElement.weather[0].icon}$WEATHER_ICON_SUFFIX',
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Text(
              '${forecastElement.main.tempMax}/${forecastElement.main.tempMin}\u00B0')
        ],
      ),
    );
  }
}
