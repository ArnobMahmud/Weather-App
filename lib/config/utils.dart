import 'package:intl/intl.dart';

const weather_api_key = '8b4552f101de3123665e6263f8acbaa7';
String getFormattedDate(int date, String format) =>
    DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
const WEATHER_ICON_PREFIX = 'https://openweathermap.org/img/wn/';
const WEATHER_ICON_SUFFIX = '@2x.png';
