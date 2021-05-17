import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../data/weather_data.dart';
import 'dart:convert';

addWeatherInfoToSF(String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('weatherInfo', data);
}

Future<String> getWeatherInfoSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String value = prefs.getString('weatherInfo');
  if (value == null) {
    addWeatherInfoToSF(json.encode({
      'rain': true,
      'windSpeed': true,
      'temp': true,
      'feelTemp': true,
      'humidity': false,
      'highest': false,
      'lowest': false,
    }));
    return json.encode({
      'rain': true,
      'windSpeed': true,
      'temp': true,
      'feelTemp': true,
      'humidity': false,
      'highest': false,
      'lowest': false,
    });
  }
  return value;
}

const color1 = Color.fromRGBO(221, 194, 159, 1);
var rain = true;
var windSpeed = true;
var temp = true;
var feelTemp = true;
var humidity = true;
var highest = true;
var lowest = true;
Map info = {
  'rain': true,
  'windSpeed': true,
  'temp': true,
  'feelTemp': true,
  'humidity': false,
  'highest': false,
  'lowest': false,
};

class weather_page extends StatefulWidget {
  @override
  _weather_pageState createState() => _weather_pageState();
}

class _weather_pageState extends State<weather_page> {
  var weatherInfo;
  Future getWeatherInfo() async {
    weatherInfo = await getWeatherInfoSF();
  }

  bool stopAdding = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // print('weatherInfo: $weatherInfo');
    // var info_1 = weatherInfo ?? json.encode(info);
    // info = json.decode(info_1);
    //getWeatherInfo();
    //print(info.);
    //print(info[temp]);

    //getWeatherInfo();
    String skyRoute = Provider.of<WeatherData>(context).skyRoute;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var perW = w / 360;
    var perH = h / 640;
    return FutureBuilder(
        future: getWeatherInfoSF(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            info = json.decode(snapshot.data);
            for (var key in info.keys) {
              //確認選擇的數量
              if (info[key]) count += 1;
            }
            if (count == 4) {
              //如果選擇的數量為4，則不能選取
              stopAdding = true;
              count = 0;
            } else {
              stopAdding = false;
              count = 0;
            }
            return Material(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: new ExactAssetImage(
                        skyRoute ?? "assets/images/sky/day.png"),
                    fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(
                    //   Colors.white.withOpacity(1.0),
                    //   BlendMode.color,
                    // ),
                  ),
                ),
                alignment: Alignment.topCenter,
                child: Container(
                  color: Colors.white.withOpacity(0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 0.01 * h,
                      ),
                      Row(
                        //返回按鈕及'外出時間設定'文字
                        children: [
                          SizedBox(width: perW * 15),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: perW * 48,
                              height: perH * 37,
                              child: Image.asset(
                                "assets/images/toolIcon/return.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: perW * 50,
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 60,
                              width: 150,
                              child: Text(
                                '天氣資訊設定',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                            //height: 300,
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //     crossAxisCount: 3, //横轴三个子widget
                              //     childAspectRatio: 1.0 //宽高比为1时，子widget
                              //     ),
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: perW * 50,
                                        height: perH * 50,
                                        child: Image.asset(
                                          'assets/images/weatherIcon/precipprob.png',
                                          fit: BoxFit.contain,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: perW * 55, right: perW * 22),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (stopAdding) {
                                              if (info['rain']) {
                                                info['rain'] = !info['rain'];
                                              }
                                            } else {
                                              info['rain'] = !info['rain'];
                                            }
                                            //print(info);
                                            addWeatherInfoToSF(
                                                json.encode(info));
                                            getWeatherInfo();
                                            // stopAdding
                                            //     ? info['rain'] = info['rain']
                                            //     : info['rain'] = !info['rain'];
                                            // info['rain']
                                            //     ? count += 1
                                            //     : count == 0
                                            //         ? count = 0
                                            //         : count -= 1;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: AnimatedContainer(
                                            height: perW * 35,
                                            width: perW * 185,
                                            decoration: BoxDecoration(
                                              color: info['rain']
                                                  ? color1
                                                  : Colors
                                                      .white, //Colors.transparent,
                                              // border: Border.all(
                                              //   width: 3,
                                              //   color: color1,
                                              // ),
                                              // borderRadius:
                                              //     BorderRadius.circular(12.0)
                                            ),
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Center(
                                              child: Text(
                                                '降雨機率',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: perH * 30),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: perW * 50,
                                        height: perH * 50,
                                        child: Image.asset(
                                          'assets/images/weatherIcon/windSpeed.png',
                                          fit: BoxFit.contain,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: perW * 55, right: perW * 22),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (stopAdding) {
                                              if (info['windSpeed']) {
                                                info['windSpeed'] =
                                                    !info['windSpeed'];
                                              }
                                            } else {
                                              info['windSpeed'] =
                                                  !info['windSpeed'];
                                            }
                                            //print(info);
                                            addWeatherInfoToSF(
                                                json.encode(info));
                                            getWeatherInfo();
                                            // info['windSpeed']
                                            //     ? count += 1
                                            //     : count == 0
                                            //         ? count = 0
                                            //         : count -= 1;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: AnimatedContainer(
                                            height: perW * 35,
                                            width: perW * 185,
                                            color: info['windSpeed']
                                                ? color1
                                                : Colors.white,
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Center(
                                              child: Text(
                                                '風速',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: perH * 30),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: perW * 50,
                                        height: perH * 50,
                                        child: Image.asset(
                                          'assets/images/weatherIcon/temp.png',
                                          fit: BoxFit.contain,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: perW * 55, right: perW * 22),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (stopAdding) {
                                              if (info['temp']) {
                                                info['temp'] = !info['temp'];
                                              }
                                            } else {
                                              info['temp'] = !info['temp'];
                                            }
                                            addWeatherInfoToSF(
                                                json.encode(info));
                                            getWeatherInfo();
                                            // info['temp']
                                            //     ? count += 1
                                            //     : count == 0
                                            //         ? count = 0
                                            //         : count -= 1;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: AnimatedContainer(
                                            height: perW * 35,
                                            width: perW * 185,
                                            color: info['temp']
                                                ? color1
                                                : Colors.white,
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Center(
                                              child: Text(
                                                '溫度',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: perH * 30),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: perW * 50,
                                        height: perH * 50,
                                        child: Image.asset(
                                          'assets/images/weatherIcon/feelTemp.png',
                                          fit: BoxFit.contain,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: perW * 55, right: perW * 22),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (stopAdding) {
                                              if (info['feelTemp']) {
                                                info['feelTemp'] =
                                                    !info['feelTemp'];
                                              }
                                            } else {
                                              info['feelTemp'] =
                                                  !info['feelTemp'];
                                            }
                                            addWeatherInfoToSF(
                                                json.encode(info));
                                            getWeatherInfo();
                                            // info['feelTemp']
                                            //     ? count += 1
                                            //     : count == 0
                                            //         ? count = 0
                                            //         : count -= 1;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: AnimatedContainer(
                                            height: perW * 35,
                                            width: perW * 185,
                                            color: info['feelTemp']
                                                ? color1
                                                : Colors.white,
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Center(
                                              child: Text(
                                                '體感溫度',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: perH * 30),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: perW * 50,
                                        height: perW * 50,
                                        child: Image.asset(
                                          'assets/images/weatherIcon/humidity.png',
                                          fit: BoxFit.contain,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: perW * 55, right: perW * 22),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (stopAdding) {
                                              if (info['humidity']) {
                                                info['humidity'] =
                                                    !info['humidity'];
                                              }
                                            } else {
                                              info['humidity'] =
                                                  !info['humidity'];
                                            }
                                            addWeatherInfoToSF(
                                                json.encode(info));
                                            getWeatherInfo();
                                            // info['humidity']
                                            //     ? count += 1
                                            //     : count == 0
                                            //         ? count = 0
                                            //         : count -= 1;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: AnimatedContainer(
                                            height: perW * 35,
                                            width: perW * 185,
                                            color: info['humidity'] ?? false
                                                ? color1
                                                : Colors.white,
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Center(
                                              child: Text(
                                                '濕度',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Icon(Icons.beach_access),
                                //Icon(Icons.cake),
                                //Icon(Icons.free_breakfast),
                              ],
                            )),
                      ),
                      Expanded(
                          child: SizedBox(
                        height: perH * 20,
                        width: 200,
                      )),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                '設定需要的詳細天氣資訊,\n將會在畫面上方資訊欄顯示',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Material(
              child: Text('hi'),
            );
          }
        });
  }
}
