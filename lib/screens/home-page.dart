import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/config/utils.dart';
import 'package:weather_app/provider/weather-provider.dart';
import 'package:weather_app/widgets/forecast_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherProvider weatherProvider;
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    weatherProvider
        .fetchCurrentData()
        .then((_) => {
              weatherProvider.fetchForecastData().then((_) => {
                    setState(() {
                      isLoading = false;
                    })
                  })
            })
        .catchError((err) {
      throw err;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        title: Text(
          'Weather App',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<WeatherProvider>(
              builder: (context, providerObject, _) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' ${providerObject.getCurrentData.name}, ${providerObject.getCurrentData.sys.country}',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      getFormattedDate(providerObject.getCurrentData.dt,
                          'EEE, MMM dd, yyyy'),
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      ' ${providerObject.getCurrentData.main.temp.round()}\u00B0C',
                      style: TextStyle(
                          fontSize: 90.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Feels Like :  ${providerObject.getCurrentData.main.feelsLike.round()}\u00B0C',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          '$WEATHER_ICON_PREFIX${providerObject.getCurrentData.weather[0].icon}$WEATHER_ICON_SUFFIX',
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          ' ${providerObject.getCurrentData.weather[0].main}, ${providerObject.getCurrentData.weather[0].description}',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: providerObject.getforecastData.list.length,
                          itemBuilder: (context, index) => ForecastList(
                              forecastElement:
                                  providerObject.getforecastData.list[index])),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
