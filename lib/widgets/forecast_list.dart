import 'package:flutter/material.dart';
import 'package:weather_app/config/utils.dart';
import 'package:weather_app/models/forecast-weather-model.dart';

class ForecastList extends StatelessWidget {
  final ForecastElement forecastElement;

  const ForecastList({Key key, this.forecastElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.blueGrey[100].withOpacity(.5),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            getFormattedDate(forecastElement.dt, 'EEE'),
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          ),
          Text(
            getFormattedDate(forecastElement.dt, 'h a'),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: Image.network(
              '$WEATHER_ICON_PREFIX${forecastElement.weather[0].icon}$WEATHER_ICON_SUFFIX',
              height: 100.0,
              width: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            '${forecastElement.main.tempMax}\u00B0/${forecastElement.main.tempMin}\u00B0',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
