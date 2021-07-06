import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as GeoCoding;
import 'package:provider/provider.dart';
import 'package:weather_app/config/utils.dart';
import 'package:weather_app/provider/weather-provider.dart';
import 'package:weather_app/widgets/forecast_list.dart';
import 'package:geolocator/geolocator.dart';

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
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) {
      print('lat : ${position.latitude} lng :${position.longitude}');
      _getWeather(position);
    }).catchError((err) {
      throw err;
    });
    super.didChangeDependencies();
  }

  _getWeather(position) {
    weatherProvider
        .fetchCurrentData(position)
        .then((_) => {
              weatherProvider.fetchForecastData(position).then((_) => {
                    setState(() {
                      isLoading = false;
                    })
                  })
            })
        .catchError((err) {
      throw err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Weather App',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30.0,
                ),
                onPressed: () {
                  showSearch(context: context, delegate: _CitySearchDelegate())
                      .then((city) {
                    if (city != null) {
                      print(city);
                      _getWeatherByCityName(city);
                    }
                  });
                })
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Opacity(
                    opacity: .87,
                    child: Image.asset(
                      'images/weather2.jpg',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Consumer<WeatherProvider>(
                      builder: (context, providerObject, _) => Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    ' ${providerObject.getCurrentData.name}, ${providerObject.getCurrentData.sys.country}',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    getFormattedDate(
                                        providerObject.getCurrentData.dt,
                                        'EEE, MMM dd, yyyy'),
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    ' ${providerObject.getCurrentData.main.temp.round()}\u00B0C',
                                    style: TextStyle(
                                        fontSize: 80.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Humidity ${providerObject.getCurrentData.main.humidity}',
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image.network(
                                        '$WEATHER_ICON_PREFIX${providerObject.getCurrentData.weather[0].icon}$WEATHER_ICON_SUFFIX',
                                        height: 65.0,
                                        width: 65.0,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        ' ${providerObject.getCurrentData.weather[0].main}',
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Sunrise : ${getFormattedDate(providerObject.getCurrentData.sys.sunrise, 'hh:mm a')} | Sunset ${getFormattedDate(providerObject.getCurrentData.sys.sunset, 'hh:mm a')}',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // height: MediaQuery.of(context).size.height * .38,
                                child: ListView.builder(
                                    padding: EdgeInsets.all(8.0),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: providerObject
                                        .getforecastData.list.length,
                                    itemBuilder: (context, index) =>
                                        ForecastList(
                                            forecastElement: providerObject
                                                .getforecastData.list[index])),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }

  void _getWeatherByCityName(String city) {
    GeoCoding.locationFromAddress(city).then((locationList) {
      if (locationList != null && locationList.length > 0) {
        double lat = locationList.first.latitude;
        double lng = locationList.first.longitude;
        final position = Position(longitude: lng, latitude: lat);
        _getWeather(position);
      }
    }).catchError((error) {
      throw error;
    });
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      title: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var filteredList = query == null
        ? cities
        : cities
            .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = filteredList[index];
        },
        title: Text(filteredList[index]),
      ),
      itemCount: filteredList.length,
    );
  }
}
