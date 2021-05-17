//not longer being use

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:http/http.dart' as http;
import './data/weather_data.dart';
import './data/weatherData.dart';
import 'weatherDataBase.dart' as weatherDataBase;
// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;

class Weather extends StatefulWidget {
  double timeNow;
  List date;
  List dateTomorrow;
  Weather(
      {@required this.timeNow,
      @required this.date,
      @required this.dateTomorrow});
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Future weather() async {
    await weatherDataBase.weatherDataBase(
        widget.timeNow, widget.date, widget.dateTomorrow);
    List<Map<String, dynamic>> data =
        await ConnectWeatherData.instance.queryAll();
    if (data.isNotEmpty) {
      print(data);
      Provider.of<WeatherData>(context)
          .editSunRise(json.decode(data[0]['sunRise']));
      Provider.of<WeatherData>(context)
          .editSunSet(json.decode(data[0]['sunSet']));
      Provider.of<WeatherData>(context)
          .editCloudCover(json.decode(data[0]['cloudCover']));
      Provider.of<WeatherData>(context).editTemp(json.decode(data[0]['temp']));
      Provider.of<WeatherData>(context)
          .editFeelTemp(json.decode(data[0]['feelTemp']));
      Provider.of<WeatherData>(context)
          .editWindSpeed(json.decode(data[0]['windSpeed']));
      Provider.of<WeatherData>(context)
          .editPrecipProb(json.decode(data[0]['precipprob']));
      Provider.of<WeatherData>(context)
          .editHumidity(json.decode(data[0]['humidity']));
      Provider.of<WeatherData>(context).editGetWeather();
    }

    //print(Provider.of<WeatherData>(context).sunRise);
    // var description = data['weather']['description'];
    // var temp = data['main']['temp'];
  }

  @override
  Widget build(BuildContext context) {
    weather();
    return SizedBox.shrink();
    // StreamBuilder(
    //   stream: Stream.periodic(Duration(days: 1)).asyncMap((i) => weather(
    //       widget.timeNow, widget.date)), // i is null here (check periodic docs)
    //   builder: (context, snapshot) => SizedBox
    //       .shrink(), // builder should also handle the case when data is not fetched yet
    // );
  }
}
