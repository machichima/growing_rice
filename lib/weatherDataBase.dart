import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import './data/weatherData.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}

Future<List> loc() async {
  var position = await determinePosition();
  Coordinates coor = Coordinates(position.latitude, position.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coor);
  return [addresses.first.adminArea, addresses.first.countryCode];
}

Future weatherDataBase(double timeNow, List date, List dateTomorrow) async {
  List<Map<String, dynamic>> data =
      await ConnectWeatherData.instance.queryAll();
  if (data.isNotEmpty && data != null) {
    print(data[0]['lastUpdateTime']);
    print('${date[0]}-${date[1]}-${date[2]}');
    if (data[0]['lastUpdateTime'] == '${date[0]}-${date[1]}-${date[2]}') {
      print('same day');
      return;
    }
  }

  List sunRise = [];
  List sunSet = [];
  List cloudcover = [];
  List temp = [];
  List feelTemp = [];
  List windSpeed = [];
  List precipprob = [];
  List humidity = [];
  List tempMax = [];
  List tempMin = [];
  var position = await loc();
  print(position); //得到 [城市名稱, 國家簡寫]
  var cityName = [];
  for (int i = 0; i < position[0].split(' ').length; i++) {
    cityName.add(position[0].split(' ')[i]);
  }
  String cityNameString = '';
  for (int i = 0; i < cityName.length; i++) {
    cityNameString = cityNameString + '%20' + '${cityName[i]}';
  }
  var url =
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityNameString%2C%20${position[1]}/${date[0]}-${date[1]}-${date[2]}/${dateTomorrow[0]}-${dateTomorrow[1]}-${dateTomorrow[2]}?unitGroup=metric&key=JJ6DAJFHVVMEH3ZDA5WA9RH9A&include=fcst%2Chours';
  print(url);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var values = json.decode(
        response.body.toString()); //await rootBundle.loadString(response.body)
    //print(values['days'][0]['hours'][10]);
    // print(values['days'][0]['hours'][8]['temp']);
    // print(values['days'][0]['hours'][8]['feelslike']);
    // print(values['days'][0]['tempmax']);
    // print(values['days'][0]['tempmin']);
    //tempMax.add(values['days'][0]['tempmax']);
    //tempMin.add(values['days'][0]['tempmin']);

    sunRise.add(int.parse(values['days'][0]['sunrise'].split(':')[0]));
    sunSet.add(int.parse(values['days'][0]['sunset'].split(':')[0]));

    for (int i = timeNow.toInt(); //first day
        i < values['days'][0]['hours'].length;
        i++) {
      cloudcover.add(values['days'][0]['hours'][i]['cloudcover']);
      temp.add(values['days'][0]['hours'][i]['temp']);
      feelTemp.add(values['days'][0]['hours'][i]['feelslike']);
      windSpeed.add(values['days'][0]['hours'][i]['windspeed']);
      precipprob.add(values['days'][0]['hours'][i]['precipprob']);
      humidity.add(values['days'][0]['hours'][i]['humidity']);
    }
    if (timeNow + 23 >= 24) {
      //second day
      sunRise.add(int.parse(values['days'][1]['sunrise'].split(':')[0]));
      sunSet.add(int.parse(values['days'][1]['sunset'].split(':')[0]));

      for (int i = 0; i < values['days'][1]['hours'].length; i++) {
        cloudcover.add(values['days'][1]['hours'][i]['cloudcover']);
        temp.add(values['days'][1]['hours'][i]['temp']);
        feelTemp.add(values['days'][1]['hours'][i]['feelslike']);
        windSpeed.add(values['days'][1]['hours'][i]['windspeed']);
        precipprob.add(values['days'][1]['hours'][i]['precipprob']);
        humidity.add(values['days'][1]['hours'][i]['humidity']);
      }
    }
  }
  ConnectWeatherData.instance.update({
    ConnectWeatherData.weatherId: 1,
    ConnectWeatherData.lastUpdateTime: '${date[0]}-${date[1]}-${date[2]}',
    ConnectWeatherData.sunRise: '$sunRise',
    ConnectWeatherData.sunSet: '$sunSet',
    ConnectWeatherData.cloudCover: '$cloudcover',
    ConnectWeatherData.temp: '$temp',
    ConnectWeatherData.feelTemp: '$feelTemp',
    ConnectWeatherData.windSpeed: '$windSpeed',
    ConnectWeatherData.precipprob: '$precipprob',
    ConnectWeatherData.humidity: '$humidity',
  });

  //print(Provider.of<WeatherData>(context).sunRise);
  // var description = data['weather']['description'];
  // var temp = data['main']['temp'];
}
