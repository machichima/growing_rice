import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:growingrice_withalarm/data/cropData.dart';
import 'package:growingrice_withalarm/data/weatherData.dart';
import 'package:growingrice_withalarm/data/weather_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sky.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sun_moon.dart';
import '../weatherDataBase.dart';
import '../weatherIcon.dart';
import 'alarm_main.dart';

Future<List> getClockValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  List value = [prefs.getInt('outTime'), prefs.getInt('backTime')];
  return value;
}

class NotificationScreen extends StatefulWidget {
  final String payload;
  NotificationScreen({this.payload});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<String> getWeatherInfoSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String value = prefs.getString('weatherInfo');
    return value;
  }

  AudioPlayer audioPlayer = AudioPlayer();

  playLocal() async {
    int result = await audioPlayer.play(widget.payload, isLocal: true);
    print('start to play');
  }

  var currenttime = DateTime.now();
  bool buttom1 = true;
  bool buttom2 = true;
  bool buttom3 = true;
  bool buttom4 = true;
  bool buttom5 = true;
  int weather = 1;
  bool changeCrop = false;
  int cropType = 1;
  List position;
  int countVal = 0;
  var weatherdata;
  List weatherIcon = ['precipprob', 'windSpeed', 'temp', 'feelTemp'];
  int times = 0;
  int secondNow = DateTime.now().second.toInt();
  bool show = false;
  double angle = 0.0;
  double endangle = 30 / 360;
  int cloudType, cloudVal;
  //Animation<double> _animation;
  //double _upperValue = 180;
  double picSize = 100;
  bool noMoon = false;
  int day; //DateTime.now().day;
  double val = DateTime.now().hour.toDouble();
  double timeNow = DateTime.now().hour.toDouble();
  var date = [DateTime.now().year, DateTime.now().month, DateTime.now().day];
  var dateTomorrow = [
    DateTime.now().add(Duration(days: 1)).year,
    DateTime.now().add(Duration(days: 1)).month,
    DateTime.now().add(Duration(days: 1)).day
  ];
  var cropChangeDate = [
    DateTime.now().add(Duration(days: 7)).year,
    DateTime.now().add(Duration(days: 7)).month,
    DateTime.now().add(Duration(days: 7)).day
  ];

  var random = Random();

  @override
  Widget build(BuildContext context) {
    List outBackTime;
    Future getOutTime() async {
      //得到出門及回家時間
      outBackTime = await getClockValuesSF();
      return outBackTime;
    }

    int moonRise = 15;
    int moonFall = 2;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var perW = w / 360;
    var perH = h / 640;
    var moonDay = [
      3,
      5,
      7,
      8,
      9,
      10,
      11,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      23,
      24,
      25,
      26
    ];
    day = DateTime.now().day;
    if (!show) val = DateTime.now().hour.toDouble();
    if (val >= 24) day += 1; //過一天所以day要加一
    double val_12 = val >= 24 ? val - 24 : val;
    if (!moonDay.contains(day)) {
      //當日期不在moon圖片中時
      if (day > 26 || day < 3)
        noMoon = true;
      else {
        var greater = moonDay.where((e) => e >= day).toList()..sort();
        day = greater[0];
      }
    }
    if (moonFall < moonRise)
      moonFall += 24; //如果是晚上到半夜的話，月亮落下的時間小於升起的時間，所以落下的時間要再加24

    var clockTime = (val % 12 == 0 ? 12 : val % 12).toInt();

    if (countVal == 0) {
      cloudType = random.nextInt(2); //距離從左邊開始算或從右邊開始算
      cloudVal = random.nextInt(800); //相對左右邊的距離
      print(date);
    }
    countVal++;

    Future<List> cropData() async {
      List<Map<String, dynamic>> cropdata =
      await ConnectCropData.instance.queryAll();
      if (cropdata.isNotEmpty) {
        print(cropdata);
        var cropdata_1 = cropdata[0]['nextDate'];
        var cropdataType = cropdata[0]['cropType'];
        return [cropdata_1, cropdataType];
      }
      return ['0000-00-00', 1];
    }

    Future<String> getWeatherInfoSF() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      String value = prefs.getString('weatherInfo');
      return value;
    }

    void getcropdata() async {
      //決定稻子是否更換樣式
      var c = await cropData();
      print(c);
      var cropDate = c[0].split('-');
      int cropDateTotal = int.parse(cropDate[0]) * 365 +
          int.parse(cropDate[1]) * 30 +
          int.parse(cropDate[2]);
      changeCrop = (cropDateTotal <= (date[0] * 365 + date[1] * 30 + date[2]));
      print(changeCrop);
      if (changeCrop || c[0] == '0000-00-00') {
        ConnectCropData.instance.update({
          ConnectCropData.cropId: 1,
          ConnectCropData.cropType:
          c[0] == '0000-00-00' ? 1 : (c[1] == 13 ? 1 : c[1] + 1),
          ConnectCropData.nextDate:
          "${cropChangeDate[0]}-${cropChangeDate[1]}-${cropChangeDate[2]}"
        });
        cropType = c[1] == 13 ? 1 : c[1] + 1;
      }
    }

    List weaDataTimeFunc(int timeNow, int outTime, int backTime) {
      int startAverageWeaTime = 0, endAverageWeaTime = 0;
      if (outTime > backTime) {
        backTime += 24;
      }
      int outsideTime = backTime - outTime;
      if (timeNow > outTime) {
        int x = timeNow - outTime;
        if (x > outsideTime) {
          print(24 - x); //start index
          startAverageWeaTime = (24 - x);
          endAverageWeaTime = startAverageWeaTime + outsideTime;
          return [startAverageWeaTime, endAverageWeaTime];
        }
        if (x < outsideTime) {
          print(backTime - timeNow);
          startAverageWeaTime = 0;
          endAverageWeaTime = backTime - timeNow;
          //start = timeNow
          //end = backTime - timeNow
          return [startAverageWeaTime, endAverageWeaTime];
        }
      }
      if (timeNow < outTime) {
        print(outTime - timeNow);
        print(outTime - timeNow + outsideTime);
        startAverageWeaTime = outTime - timeNow;
        endAverageWeaTime = startAverageWeaTime + outsideTime;
        //start index = outTime - timeNow
        //end = index + outDoorTime
        return [startAverageWeaTime, endAverageWeaTime];
      }
    }

    getcropdata();
    getWeatherInfoSF();
    getOutTime();
    weatherDataBase(timeNow, date, dateTomorrow);

    return FutureBuilder<List>(
        future: Future.wait([
          ConnectWeatherData.instance.queryAll(),
          getWeatherInfoSF(),
          getOutTime()
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          print(snapshot.data);
          if (snapshot
              .hasData) //if (Provider.of<WeatherData>(context).getWeather) //
              {
            print('////////////////////////////////////////////////////////');
            print(snapshot.data);
            int sunRise = // weatherdata != null
            val >= 24
                ? json.decode(snapshot.data[0][0]['sunRise'])[0]
                : json.decode(snapshot.data[0][0]['sunRise'])[1]; //6;
            int sunFall = val >= 24
                ? json.decode(snapshot.data[0][0]['sunSet'])[0]
                : json.decode(snapshot.data[0][0]['sunSet'])[1];
            String skyRoute = val_12 == sunRise + 1 || val_12 == sunFall - 1
                ? 'assets/images/sky/day_sep.png'
                : val_12 == sunRise || val_12 == sunFall
                ? 'assets/images/sky/sun_rise_fall.png'
                : val_12 == sunRise - 1 || val_12 == sunFall + 1
                ? 'assets/images/sky/night_sep.png'
                : val_12 > sunFall + 1 || val_12 < sunRise - 1
                ? 'assets/images/sky/night.png'
                : 'assets/images/sky/day.png';

            List weaDataTime = weaDataTimeFunc(
                timeNow.toInt(), snapshot.data[2][0], snapshot.data[2][1]);

            List cloudCoverData = json
                .decode(snapshot.data[0][0]['cloudCover'])
                .sublist(weaDataTime[0], weaDataTime[1]);
            //timeNow.toInt(), snapshot.data[2][1]
            List tempData = json
                .decode(snapshot.data[0][0]['temp'])
                .sublist(weaDataTime[0], weaDataTime[1]);
            int maxTemp =
            (tempData.reduce((curr, next) => curr + next) / tempData.length)
                .toInt();

            List feelTempData = json
                .decode(snapshot.data[0][0]['feelTemp'])
                .sublist(weaDataTime[0], weaDataTime[1]);
            int maxFeelTemp =
            (feelTempData.reduce((curr, next) => curr + next) /
                feelTempData.length)
                .toInt();

            List precipprobData = json
                .decode(snapshot.data[0][0]['precipprob'])
                .sublist(weaDataTime[0], weaDataTime[1]);
            int maxPrecipprob =
            (precipprobData.reduce((curr, next) => curr + next) /
                precipprobData.length)
                .toInt();

            List windSpeedData = json
                .decode(snapshot.data[0][0]['windSpeed'])
                .sublist(weaDataTime[0], weaDataTime[1]);
            int maxWindSpeed =
            (windSpeedData.reduce((curr, next) => curr + next) /
                windSpeedData.length)
                .toInt();

            List humidityData = json
                .decode(snapshot.data[0][0]['windSpeed'])
                .sublist(weaDataTime[0], weaDataTime[1]);
            int maxHumidity =
            (humidityData.reduce((curr, next) => curr + next) /
                humidityData.length)
                .toInt();

            for (int i = timeNow.toInt();
            i < snapshot.data[2][1] - timeNow.toInt();
            i++) {
              //確認在當下時間到回家時間的期間會不會下雨
              if (precipprobData[i] >= 30) {
                weather = 2;
                break;
              }
              if (cloudCoverData[i] >= 50) {
                //確認在當下時間到回家時間的期間是不是陰天
                weather = 3;
              }
            }

            Map info = json.decode(snapshot.data[1] ??
                json.encode({
                  'rain': true,
                  'windSpeed': true,
                  'temp': true,
                  'feelTemp': true,
                  'humidity': false,
                  'highest': false,
                  'lowest': false,
                }));
            return Scaffold(
              body: Stack(
                children: [
                  Sky(
                    //天空
                    val: val,
                    sunRise: sunRise,
                    sunFall: sunFall,
                    route: skyRoute,
                  ),
                  (weather == 2) //raining
                      ? Container(
                    child: Image.asset(
                      'assets/images/cloud/raining.gif',
                      fit: BoxFit.fill,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  )
                      : Container(),
                  SunMoon(
                    //sun
                    val: val,
                    rise: sunRise - 1,
                    fall: sunFall + 1,
                    route: val_12 <= sunRise + 2
                        ? 'assets/images/sun/sun_morning.png'
                        : val_12 >= sunFall - 2
                        ? 'assets/images/sun/sun_afternoon.png'
                        : 'assets/images/sun/sun_noon.png',
                    isMoon: false,
                  ),
                  SunMoon(
                    //moon
                    val: val,
                    rise: moonRise - 1,
                    fall: moonFall + 1,
                    route: 'assets/images/moon/moon_$day.png',
                    noMoon: noMoon,
                    isMoon: true,
                  ),
                  Positioned(
                    //cloud
                      height: h,
                      left: cloudType == 0 ? -cloudVal.toDouble() : null,
                      right: cloudType == 1 ? -cloudVal.toDouble() : null,
                      child: val_12 <= sunFall && val_12 >= sunRise
                          ? weather == 3
                          ? Image.asset(
                          'assets/images/cloud/day_cloudy.png')
                          : Image.asset('assets/images/cloud/day_cloud.png')
                          : weather == 3
                          ? Image.asset(
                          'assets/images/cloud/night_cloudy.png')
                          : Image.asset(
                          'assets/images/cloud/night_cloud.png')),
                  Positioned(
                    left: 15,
                    top: MediaQuery.of(context).padding.top + 0.01 * h,
                    child: Container(
                      width: w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (info['temp'])
                            WeatherIcon(
                              iconTypeName: 'temp',
                              iconType: maxTemp,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall,
                              alarmpage: true,
                            ),
                          if (info['feelTemp'])
                            WeatherIcon(
                              iconTypeName: 'feelTemp',
                              iconType: maxFeelTemp,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall,
                              alarmpage: true,
                            ),
                          if (info['rain'])
                            WeatherIcon(
                              iconTypeName: 'precipprob',
                              iconType: maxPrecipprob,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall,
                              alarmpage: true,
                            ),
                          if (info['windSpeed'])
                            WeatherIcon(
                              iconTypeName: 'windSpeed',
                              iconType: maxWindSpeed,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall,
                              alarmpage: true,
                            ),
                          if (info['humidity'])
                            WeatherIcon(
                              iconTypeName: 'humidity',
                              iconType: maxHumidity,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall,
                              alarmpage: true,
                            ),
                        ],
                      ),
                    ),
                  ),
/////////////////////////////////////////////////////////////////////////
                  // if (Provider.of<WeatherData>(context).getWeather)
                  //   Positioned(
                  //     top: 50,
                  //     child: FlatButton(
                  //       child: Container(
                  //         width: 50,
                  //         height: 50,
                  //         color: Colors.black,
                  //       ),
                  //       onPressed: () async {
                  //         int i = await ConnectCropData.instance.insertCrop({
                  //           ConnectCropData.cropId: 1,
                  //           ConnectCropData.cropType: 1,
                  //           ConnectCropData.nextDate:
                  //               "${cropChangeDate[0]}-${cropChangeDate[1]}-${cropChangeDate[2]}"
                  //         });
                  //         print('data insert $i');
                  //       },
                  //     ),
                  //   ),
                  // if (Provider.of<WeatherData>(context).getWeather)
                  //   Positioned(
                  //     top: 100,
                  //     child: FlatButton(
                  //       child: Container(
                  //         width: 50,
                  //         height: 50,
                  //         color: Colors.green,
                  //       ),
                  //       onPressed: () async {
                  //         List<Map<String, dynamic>> i =
                  //             await ConnectCropData.instance.queryAll();
                  //         print(i);
                  //       },
                  //     ),
                  //   ),
                  // if (Provider.of<WeatherData>(context).getWeather)
                  //   Positioned(
                  //     top: 150,
                  //     child: FlatButton(
                  //       child: Container(
                  //         width: 50,
                  //         height: 50,
                  //         color: Colors.blue,
                  //       ),
                  //       onPressed: () async {
                  //         int i = await ConnectCropData.instance.update({
                  //           ConnectCropData.cropId: 1,
                  //           ConnectCropData.cropType: 1,
                  //           ConnectCropData.nextDate:
                  //               "${cropChangeDate[0]}-${cropChangeDate[1]}-${cropChangeDate[2]}"
                  //         });
                  //         print(i);
                  //       },
                  //     ),
                  //   ),
                  // if (Provider.of<WeatherData>(context).getWeather)
                  //   Positioned(
                  //     top: 200,
                  //     child: FlatButton(
                  //       child: Container(
                  //         width: 50,
                  //         height: 50,
                  //         color: Colors.red,
                  //       ),
                  //       onPressed: () async {
                  //         int i = await ConnectCropData.instance.delete(1);
                  //         print(i);
                  //       },
                  //     ),
                  //   ),
/////////////////////////////////////////////////////////////////////
                  Positioned(
                    //soil
                    top: h * 0.9,
                    //bottom: -h * 0.2,
                    child: Container(
                      width: w,
                      child: Image.asset(
                        val_12 == sunRise + 1 || val_12 == sunFall - 1
                            ? 'assets/images/soil/day_sep_soil.png'
                            : val_12 == sunRise || val_12 == sunFall
                            ? 'assets/images/soil/sun_rise_fall_soil.png'
                            : val_12 == sunRise - 1 || val_12 == sunFall + 1
                            ? 'assets/images/soil/night_sep_soil.png'
                            : val_12 > sunFall + 1 ||
                            val_12 < sunRise - 1
                            ? 'assets/images/soil/night_soil.png'
                            : 'assets/images/soil/day_soil.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: h * 0.05,
                    child: Image.asset('assets/images/crop/crop_$cropType.png'),
                  ),
                  Positioned(
                    top: h / 3.37,
                    left: w / 6,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Color.fromRGBO(221, 194, 159, 1),
                      child: Container(
                        height: h / 6.4,
                        width: w / 3 * 2,
                        alignment: Alignment.center,
                        child: Text(
                            '${currenttime.hour} : ${currenttime.minute}',
                            style:
                            TextStyle(color: Colors.white, fontSize: 40)),
                      ),
                    ),
                  ),
                  if (weather == 2)
                    Positioned(
                      left: w / 18,
                      bottom: h / 10,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom1 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom1
                              ? Container(
                              height: h / 9,
                              width: h / 9,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/snail3.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 2)
                    Positioned(
                      right: w / 5.625,
                      bottom: h / 10,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom2 = false;
                              print('ontap');
                              print(buttom2);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom2
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/snail3.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 2)
                    Positioned(
                      right: w / 90,
                      bottom: h / 10,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom3 = false;
                              print('ontap');
                              print(buttom3);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom3
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/snail2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 2)
                    Positioned(
                      right: w / 2.5,
                      bottom: h / 11,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom4 = false;
                              print('ontap');
                              print(buttom2);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom4
                              ? Container(
                              height: h / 13,
                              width: h / 13,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/snail3.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 2)
                    Positioned(
                      left: w / 4,
                      bottom: h / 17,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom5 = false;
                              print('ontap');
                              print(buttom2);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom5
                              ? Container(
                              height: h / 15,
                              width: h / 15,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/snail2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 1)
                    Positioned(
                      left: w / 14,
                      bottom: h / 6,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom1 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom1
                              ? Container(
                              height: h / 10,
                              width: h / 10,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/麻雀2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 1)
                    Positioned(
                      right: w / 5.625,
                      bottom: h / 4,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom2 = false;
                              print('ontap');
                              print(buttom2);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom2
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/麻雀1.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 1)
                    Positioned(
                      right: w / 90,
                      bottom: h / 3,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom3 = false;
                              print('ontap');
                              print(buttom3);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom3
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/麻雀2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 1)
                    Positioned(
                      left: w / 6,
                      bottom: h / 2.5,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom4 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom4
                              ? Container(
                              height: h / 11,
                              width: h / 11,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/麻雀1.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 1)
                    Positioned(
                      left: w / 3,
                      bottom: h / 3,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom5 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom5
                              ? Container(
                              height: h / 10,
                              width: h / 10,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/麻雀1.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 3)
                    Positioned(
                      left: w / 18,
                      bottom: h / 13,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom1 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom1
                              ? Container(
                              height: h / 9,
                              width: h / 9,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/毛毛蟲2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 3)
                    Positioned(
                      right: w / 5.625,
                      bottom: h / 10,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom2 = false;
                              print('ontap');
                              print(buttom2);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom2
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/毛毛蟲1.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 3)
                    Positioned(
                      right: w / 90,
                      bottom: h / 10,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom3 = false;
                              print('ontap');
                              print(buttom3);
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom3
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/毛毛蟲2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 3)
                    Positioned(
                      left: w / 18,
                      bottom: h / 7,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom4 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom4
                              ? Container(
                              height: h / 12,
                              width: h / 12,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/毛毛蟲1.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                  if (weather == 3)
                    Positioned(
                      left: w / 2.5,
                      bottom: h / 11,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              buttom5 = false;
                              print('ontap');
                              if (buttom1 |
                              buttom2 |
                              buttom3 |
                              buttom4 |
                              buttom5 ==
                                  false) {
                                Navigator.pop(context);
                                print('pop');
                              }
                            });
                          },
                          child: buttom5
                              ? Container(
                              height: h / 10,
                              width: h / 10,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/alarm/毛毛蟲2.png'),
                                fit: BoxFit.fill,
                              ))
                              : Container()),
                    ),
                ],
              ),
            );
          } else {
            return Stack(
              children: [
                Center(
                  child: SpinKitFadingCircle(
                    color: Colors.black,
                    size: 100.0,
                  ),
                ),
              ],
            );
          }
        });
  }
}

class RainingDays extends StatefulWidget {
  @override
  _RainingDaysState createState() => _RainingDaysState();
}

class _RainingDaysState extends State<RainingDays> {
  var currenttime = DateTime.now();
  bool buttom1 = true;
  bool buttom2 = true;
  bool buttom3 = true;
  bool buttom4 = true;
  bool buttom5 = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: height / 3.37,
              left: width / 6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(221, 194, 159, 1),
                child: Container(
                  height: height / 6.4,
                  width: width / 3 * 2,
                  alignment: Alignment.center,
                  child: Text('${currenttime.hour} : ${currenttime.minute}',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                ),
              ),
            ),
            Positioned(
              left: width / 18,
              bottom: height / 10,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom1 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom1
                      ? Container(
                      height: height / 9,
                      width: height / 9,
                      child: Image(
                        image: AssetImage('assets/images/alarm/snail3.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 5.625,
              bottom: height / 10,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom2 = false;
                      print('ontap');
                      print(buttom2);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom2
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/snail3.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 90,
              bottom: height / 10,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom3 = false;
                      print('ontap');
                      print(buttom3);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom3
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/snail2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 2.5,
              bottom: height / 11,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom4 = false;
                      print('ontap');
                      print(buttom2);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom4
                      ? Container(
                      height: height / 13,
                      width: height / 13,
                      child: Image(
                        image: AssetImage('assets/images/alarm/snail3.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              left: width / 4,
              bottom: height / 17,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom5 = false;
                      print('ontap');
                      print(buttom2);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom5
                      ? Container(
                      height: height / 15,
                      width: height / 15,
                      child: Image(
                        image: AssetImage('assets/images/alarm/snail2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
          ],
        ),
      ),
    );
  }
}

class SunnyDay extends StatefulWidget {
  @override
  _SunnyDayState createState() => _SunnyDayState();
}

class _SunnyDayState extends State<SunnyDay> {
  var currenttime = DateTime.now();
  bool buttom1 = true;
  bool buttom2 = true;
  bool buttom3 = true;
  bool buttom4 = true;
  bool buttom5 = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: height / 3.37,
              left: width / 6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(221, 194, 159, 1),
                child: Container(
                  height: height / 6.4,
                  width: width / 3 * 2,
                  alignment: Alignment.center,
                  child: Text('${currenttime.hour} : ${currenttime.minute}',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                ),
              ),
            ),
            Positioned(
              left: width / 14,
              bottom: height / 6,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom1 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom1
                      ? Container(
                      height: height / 10,
                      width: height / 10,
                      child: Image(
                        image: AssetImage('assets/images/alarm/麻雀2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 5.625,
              bottom: height / 4,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom2 = false;
                      print('ontap');
                      print(buttom2);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom2
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/麻雀1.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 90,
              bottom: height / 3,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom3 = false;
                      print('ontap');
                      print(buttom3);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom3
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/麻雀2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              left: width / 6,
              bottom: height / 2.5,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom4 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom4
                      ? Container(
                      height: height / 11,
                      width: height / 11,
                      child: Image(
                        image: AssetImage('assets/images/alarm/麻雀1.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              left: width / 3,
              bottom: height / 3,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom5 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom5
                      ? Container(
                      height: height / 10,
                      width: height / 10,
                      child: Image(
                        image: AssetImage('assets/images/alarm/麻雀1.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
          ],
        ),
      ),
    );
  }
}

class WindsDay extends StatefulWidget {
  @override
  _WindsDayState createState() => _WindsDayState();
}

class _WindsDayState extends State<WindsDay> {
  var currenttime = DateTime.now();
  bool buttom1 = true;
  bool buttom2 = true;
  bool buttom3 = true;
  bool buttom4 = true;
  bool buttom5 = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: height / 3.37,
              left: width / 6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(221, 194, 159, 1),
                child: Container(
                  height: height / 6.4,
                  width: width / 3 * 2,
                  alignment: Alignment.center,
                  child: Text('${currenttime.hour} : ${currenttime.minute}',
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                ),
              ),
            ),
            Positioned(
              left: width / 18,
              bottom: height / 13,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom1 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom1
                      ? Container(
                      height: height / 9,
                      width: height / 9,
                      child: Image(
                        image: AssetImage('assets/images/alarm/毛毛蟲2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 5.625,
              bottom: height / 10,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom2 = false;
                      print('ontap');
                      print(buttom2);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom2
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/毛毛蟲1.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              right: width / 90,
              bottom: height / 10,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom3 = false;
                      print('ontap');
                      print(buttom3);
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom3
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/毛毛蟲2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              left: width / 18,
              bottom: height / 7,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom4 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom4
                      ? Container(
                      height: height / 12,
                      width: height / 12,
                      child: Image(
                        image: AssetImage('assets/images/alarm/毛毛蟲1.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
            Positioned(
              left: width / 2.5,
              bottom: height / 11,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      buttom5 = false;
                      print('ontap');
                      if (buttom1 | buttom2 | buttom3 | buttom4 | buttom5 ==
                          false) {
                        Navigator.pop(context);
                        print('pop');
                      }
                    });
                  },
                  child: buttom5
                      ? Container(
                      height: height / 10,
                      width: height / 10,
                      child: Image(
                        image: AssetImage('assets/images/alarm/毛毛蟲2.png'),
                        fit: BoxFit.fill,
                      ))
                      : Container()),
            ),
          ],
        ),
      ),
    );
  }
}