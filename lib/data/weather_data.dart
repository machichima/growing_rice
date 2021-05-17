import 'package:flutter/material.dart';

class WeatherData extends ChangeNotifier {
  bool getWeather = false;
  List sunRise;
  List sunSet;
  List cloudCover;
  List tempMax;
  List tempMin;
  List temp;
  List feelTemp;
  List windSpeed;
  List precipprob;
  List humidity;
  String skyRoute;

  void editGetWeather() {
    this.getWeather = true;
    notifyListeners();
  }

  void editSunRise(List value) {
    this.sunRise = value;
    notifyListeners();
  }

  void editSunSet(List value) {
    this.sunSet = value;
    notifyListeners();
  }

  void editCloudCover(List value) {
    this.cloudCover = value;
    notifyListeners();
  }

  void editTempMax(List value) {
    this.tempMax = value;
    notifyListeners();
  }

  void editTempMin(List value) {
    this.tempMin = value;
    notifyListeners();
  }

  void editTemp(List value) {
    this.temp = value;
    notifyListeners();
  }

  void editFeelTemp(List value) {
    this.feelTemp = value;
    notifyListeners();
  }

  void editWindSpeed(List value) {
    this.windSpeed = value;
    notifyListeners();
  }

  void editPrecipProb(List value) {
    this.precipprob = value;
    notifyListeners();
  }

  void editHumidity(List value) {
    this.humidity = value;
    notifyListeners();
  }

  void editSkyRoute(String route) {
    this.skyRoute = route;
    notifyListeners();
  }
}
