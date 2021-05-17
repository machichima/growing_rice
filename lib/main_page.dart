import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:growingrice_withalarm/alarm/NotificationPlugin.dart';
import 'package:growingrice_withalarm/alarm/alarm_main.dart';
import 'package:growingrice_withalarm/alarm/notificationscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'sky.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sun_moon.dart';
import 'weather.dart';
import './data/weather_data.dart';
import './data/cropData.dart';
import 'weatherIcon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './setting_page/setting.dart';
import 'weatherDataBase.dart';
import './data/weatherData.dart';
import 'dart:convert';

class MainPage extends StatefulWidget {
  //MainPage({@required this.show, @required this.val});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
  ///從這行
  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(context, MaterialPageRoute(builder: (coontext) {
      return NotificationScreen(
        payload: payload,
      );
    }));
  }

  ///到這行，為設定鬧種嚮的頁面;
  void initState() {
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    getcropdata();
    getWeatherInfoSF();
    weatherDataBase(timeNow, date, dateTomorrow);

    return FutureBuilder<List>(
        future: Future.wait(
            [ConnectWeatherData.instance.queryAll(), getWeatherInfoSF()]),
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
            List cloudCoverData =
                json.decode(snapshot.data[0][0]['cloudCover']);
            double cloudCover = cloudCoverData[(val - timeNow).toInt()] ?? 0;
            List tempData = json.decode(snapshot.data[0][0]['temp']);
            double temp = tempData[(val - timeNow).toInt()] ?? 0;
            List feelTempData = json.decode(snapshot.data[0][0]['feelTemp']);
            double feelTemp = feelTempData[(val - timeNow).toInt()] ?? 0;
            List precipprobData =
                json.decode(snapshot.data[0][0]['precipprob']);
            double precipprob = precipprobData[(val - timeNow).toInt()] ?? 0;
            List windSpeedData = json.decode(snapshot.data[0][0]['windSpeed']);
            double windSpeed = windSpeedData[(val - timeNow).toInt()] ?? 0;
            List humidityData = json.decode(snapshot.data[0][0]['windSpeed']);
            double humidity = humidityData[(val - timeNow).toInt()] ?? 0;

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
            return Stack(
              children: [
                Sky(
                  //天空
                  val: val,
                  sunRise: sunRise,
                  sunFall: sunFall,
                  route: skyRoute,
                ),

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
                      ? cloudCover != null
                          ? cloudCover >= 50
                              ? Image.asset(
                                  'assets/images/cloud/day_cloudy.png')
                              : Image.asset('assets/images/cloud/day_cloud.png')
                          : Image.asset('assets/images/cloud/day_cloud.png')
                      : cloudCover != null
                          ? cloudCover >= 50
                              ? Image.asset(
                                  'assets/images/cloud/night_cloudy.png')
                              : Image.asset(
                                  'assets/images/cloud/night_cloud.png')
                          : Image.asset('assets/images/cloud/night_cloud.png'),
                ),
                AnimatedPositioned(
                  //設定按鈕
                  duration: Duration(milliseconds: 300),
                  top: MediaQuery.of(context).padding.top + 0.02 * h,
                  left: show ? -(perW * 12 + w - 100) : perW * 12,
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(perW * 10)),
                      child: Container(
                        child: Icon(
                          Icons.menu_rounded,
                          color: Color(0xFF313131),
                          size: perW * 30,
                        ),
                        color: Color(0xFFDDC29F),
                        width: perW * 40,
                        height: perW * 40,
                      ),
                    ),
                    onTap: () {
                      Provider.of<WeatherData>(context, listen: false)
                          .editSkyRoute(skyRoute);
                      Navigator.of(context).push(
                        //opaque: false, // set to false

                        MaterialPageRoute(builder: (context) => setting_page()),

                        // pageBuilder: (_, __, ___) => setting_page(
                        //     skyRoute: skyRoute,
                        //   ),
                      );
                    },
                  ),
                ),
                AnimatedPositioned(
                  //clock
                  top: MediaQuery.of(context).padding.top + 0.01 * h,
                  //show ? w : -10,
                  left: show ? 0 : w - 100,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          //height: 100,
                          child: FlatButton(
                            child: Image.asset(
                              'assets/images/clock/clock_$clockTime.png',
                              fit: BoxFit.fill,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                //opaque: false, // set to false

                                MaterialPageRoute(builder: (context) => MyAlarm()),

                                // pageBuilder: (_, __, ___) => setting_page(
                                //     skyRoute: skyRoute,
                                //   ),
                              );
                            },
                          ),
                        ),
                        if (info['temp'])
                          WeatherIcon(
                              iconTypeName: 'temp',
                              iconType: temp,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall),
                        if (info['feelTemp'])
                          WeatherIcon(
                              iconTypeName: 'feelTemp',
                              iconType: feelTemp,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall),
                        if (info['rain'])
                          WeatherIcon(
                              iconTypeName: 'precipprob',
                              iconType: precipprob,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall),
                        if (info['windSpeed'])
                          WeatherIcon(
                              iconTypeName: 'windSpeed',
                              iconType: windSpeed,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall),
                        if (info['humidity'])
                          WeatherIcon(
                              iconTypeName: 'humidity',
                              iconType: humidity,
                              val_12: val_12,
                              sunRise: sunRise,
                              sunFall: sunFall),
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
                                  : val_12 > sunFall + 1 || val_12 < sunRise - 1
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
                AnimatedPositioned(
                  //拉條
                  top: (h - 350) / 2,
                  right: show ? -10 : -80,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    height: 350,
                    width: 80,
                    child: FlutterSlider(
                      handlerWidth: 80,
                      handlerHeight: 10,
                      values: [val],
                      max: timeNow + 23,
                      min: timeNow,
                      step: FlutterSliderStep(step: 1),
                      jump: true,
                      //rtl: true,
                      axis: Axis.vertical,
                      selectByTap: false,
                      // hatchMark: FlutterSliderHatchMark(
                      //   linesDistanceFromTrackBar: -50.0,
                      //   density: 0.24, // means 50 lines, from 0 to 100 percent
                      //   displayLines: true,
                      // ),
                      handler: FlutterSliderHandler(
                        //拖動條的拖動環
                        decoration: BoxDecoration(),
                        child: ClipRRect(
                          //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            color: Color(0xFF313131),
                          ),
                        ),
                        opacity: 1,
                        //disabled: true,
                      ),
                      handlerAnimation: FlutterSliderHandlerAnimation(
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.bounceIn,
                        duration: Duration(milliseconds: 300),
                        scale: 1,
                      ),

                      tooltip: FlutterSliderTooltip(
                        direction: FlutterSliderTooltipDirection.left,
                        textStyle:
                            TextStyle(fontSize: 20, color: Color(0xFF313131)),
                        alwaysShowTooltip: true,
                        disabled: !show,
                        boxStyle: FlutterSliderTooltipBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Color(0xFF313131), width: 3),
                            //borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFDDC29F),
                          ),
                        ),
                        positionOffset:
                            FlutterSliderTooltipPositionOffset(left: -38),
                        format: (value) {
                          int val = double.parse(value).toInt();
                          if (val >= 24) val -= 24;
                          if (val < 10) return '0$val';
                          return '$val';
                        },
                        //disabled: true,
                      ),
                      trackBar: FlutterSliderTrackBar(
                        //拉條背景
                        inactiveTrackBarHeight: 80,
                        activeTrackBarHeight: 80,
                        inactiveTrackBar: BoxDecoration(
                          // image: DecorationImage(
                          //   image: ExactAssetImage('assets/images/scale.png'),
                          //   fit: BoxFit.fill,
                          // ),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFDDC29F).withOpacity(0.73),
                          //border: Border.all(width: 3, color: Colors.blue),
                        ),
                        activeTrackBar: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                            color: Color(0xFFDDC29F)),
                      ),
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          val = lowerValue;
                        });
                      },
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        setState(() {
                          val = lowerValue;
                          val.toStringAsFixed(0);
                        });
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  //控制拉條出來或隱藏
                  onPanUpdate: (details) {
                    if (details.delta.dx < -10) {
                      setState(() {
                        show = true;
                        //print(Provider.of<WeatherData>(context).cloudcover.length);
                      });
                    }
                    if (details.delta.dx > 10) {
                      setState(() {
                        show = false;
                      });
                    }
                  },
                ),
              ],
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
