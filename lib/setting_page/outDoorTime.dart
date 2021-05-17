import 'package:flutter/material.dart';
import '../data/weather_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../data/outTimeProvider.dart';
import 'package:provider/provider.dart';

addClockTimeToSF(int data, bool switchBackTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (switchBackTime)
    prefs.setInt('backTime', data);
  else
    prefs.setInt('outTime', data);
}

Future<int> getClockValuesSF(bool switchBackTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  int value =
      switchBackTime ? prefs.getInt('backTime') : prefs.getInt('outTime');
  return value;
}

void main() {
  runApp(new MaterialApp(home: new OutDoorTime()));
}

class OutDoorTime extends StatefulWidget {
  //String skyRoute;
  //OutDoorTime({@required this.skyRoute});
  @override
  _OutDoorTimeState createState() => _OutDoorTimeState();
}

class _OutDoorTimeState extends State<OutDoorTime> {
  Future getOutTime(bool switchBackTime) async {
    int outTime = await getClockValuesSF(switchBackTime);
    switchBackTime
        ? Provider.of<OutTimeData>(context, listen: false).editBackTime(outTime)
        : Provider.of<OutTimeData>(context, listen: false).editOutTime(outTime);
  }

  bool switchPM = false;
  bool switchBackTime = false;
  List<Map<String, Object>> get getTimeButton {
    return List.generate(7, (index) {
      return {
        'clockTime': index,
        'angle': (index * 30) / 180 * math.pi,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    String skyRoute = Provider.of<WeatherData>(context).skyRoute;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var perH = h / 640;
    var perW = w / 360;
    getOutTime(switchBackTime);
    var clockType = switchBackTime
        ? Provider.of<OutTimeData>(context).backhomeTime
        : Provider.of<OutTimeData>(context).outdoorTime;
    switchPM = (clockType ?? 12) > 12;

    Widget bigCircle = Container(
      width: perW * 230,
      height: perW * 230,
      decoration: new BoxDecoration(
        color: Color(0xFFDDC29F),
        shape: BoxShape.circle,
        border: Border.all(
          width: 5,
          color: Color(0xFFFDf47E),
        ),
        //backgroundBlendMode: BlendMode.multiply,
      ),
    );

    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new ExactAssetImage(skyRoute ?? "assets/images/sky/day.png"),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //   Colors.white.withOpacity(1.0),
            //   BlendMode.color,
            // ),
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.6),
          child: Column(
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
                    width: perW * 42,
                  ),
                  Image.asset(
                    'assets/images/toolIcon/outDoorTimeSettingWord.png',
                    width: perW * 150,
                  ),
                ],
              ),
              SizedBox(height: perH * 59),
              Stack(
                //時鐘本體
                alignment: AlignmentDirectional.center,
                children: [
                  new Center(
                    child: new Stack(
                      alignment: AlignmentDirectional.center,
                      children: getTimeButton.map((data) {
                        if (data['clockTime'] == 6) return bigCircle;
                        // return Container(
                        //     width: 300,
                        //     child: Image.asset(
                        //       'assets/clockOutDoor.png',
                        //       fit: BoxFit.contain,
                        //     ));
                        return Positioned(
                          top: perW * 8,
                          left: perW * (230 - 27) / 2, //132.5
                          child: Transform.rotate(
                            angle: data['angle'],
                            child: circleButton(
                              context,
                              data['clockTime'],
                              switchPM,
                              switchBackTime,
                              perW,
                              perH,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          //時間(數字)
                          padding: const EdgeInsets.only(right: 3),
                          child: Text(
                            switchPM
                                ? (clockType ?? 12) <= 12
                                    ? '${(clockType ?? 12)}'
                                    : '${(clockType ?? 12) - 12}'
                                : (clockType ?? 12) > 12
                                    ? '${(clockType ?? 12) - 12}'
                                    : '${(clockType ?? 12)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: perW * 30, color: Color(0xff75563a)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            switchPM = !switchPM;
                            var clockTimeSwitch = clockType;
                            if (switchPM) {
                              switchBackTime
                                  ? Provider.of<OutTimeData>(context,
                                          listen: false)
                                      .editBackTime(clockTimeSwitch + 12)
                                  : Provider.of<OutTimeData>(context,
                                          listen: false)
                                      .editOutTime(clockTimeSwitch + 12);
                              addClockTimeToSF(
                                  clockTimeSwitch + 12, switchBackTime);
                              print(switchBackTime);
                            } else {
                              switchBackTime
                                  ? Provider.of<OutTimeData>(context,
                                          listen: false)
                                      .editBackTime(clockTimeSwitch % 12)
                                  : Provider.of<OutTimeData>(context,
                                          listen: false)
                                      .editOutTime(clockTimeSwitch % 12);
                              addClockTimeToSF(
                                  clockTimeSwitch % 12, switchBackTime);
                              print(Provider.of<OutTimeData>(context,
                                      listen: false)
                                  .outdoorTime);
                            }
                          },
                          splashColor: Colors.amber,
                          borderRadius: new BorderRadius.circular(40),
                          child: new Container(
                            width: perW * 32,
                            height: perH * 20,
                            decoration: new BoxDecoration(
                              color: Color(0xFFFDf47E),
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                switchPM ? 'PM' : 'AM',
                                style: TextStyle(
                                  fontSize: perW * 15,
                                  color: Color(0xff75563a),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: perH * 38),
              Container(
                width: perW * 141,
                height: perH * 47,
                decoration: BoxDecoration(
                  color: Color(0xFFDDC29F),
                  border: Border.all(
                    color: Color(0xFFFDf47E),
                    width: 5,
                  ),
                ),
                child: Center(
                  child: Text(
                    switchBackTime ? '回家時間' : '出門時間',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: perW * 20),
                  ),
                ),
              ),
              SizedBox(height: perH * 38),
              InkWell(
                onTap: () {
                  switchBackTime = !switchBackTime;
                  clockType = switchBackTime
                      ? Provider.of<OutTimeData>(context, listen: false)
                          .backhomeTime
                      : Provider.of<OutTimeData>(context, listen: false)
                          .outdoorTime;
                  if ((clockType ?? 12) > 12)
                    switchPM = true;
                  else
                    switchPM = false;
                  print('clockTimeNow:$clockType');
                }, // needed
                child: Container(
                  width: perW * 56,
                  height: perH * 31,
                  child: switchBackTime
                      ? Transform.rotate(
                          angle: math.pi,
                          child: Image.asset(
                            'assets/images/toolIcon/right.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/toolIcon/right.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: perH * 23),
              Container(
                height: perH * 88,
                width: perW * 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '設定外出時間，我們會提醒\n你在這段時間內的天氣資訊',
                    style: TextStyle(fontSize: perW * 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Column circleButton(BuildContext context, int clockTime, bool switchPM,
    bool switchBackTime, double perH_1, double perW_1) {
  var h = MediaQuery.of(context).size.height;
  var w = MediaQuery.of(context).size.width;
  var perH = h / 640;
  var perW = w / 360;
  double size = perW * 27;
  var clockType = switchBackTime
      ? Provider.of<OutTimeData>(context).backhomeTime
      : Provider.of<OutTimeData>(context).outdoorTime;
  return Column(
    children: [
      InkWell(
        onTap: () {
          clockTime = clockTime != 0 ? clockTime : 12;
          clockTime = switchPM ? clockTime + 12 : clockTime;
          print(clockTime);
          switchBackTime
              ? Provider.of<OutTimeData>(context, listen: false)
                  .editBackTime(clockTime)
              : Provider.of<OutTimeData>(context, listen: false)
                  .editOutTime(clockTime);
          addClockTimeToSF(clockTime, switchBackTime);
          //outTime = clockTime != 0 ? clockTime : 12;
        },
        splashColor: Colors.red,
        borderRadius: new BorderRadius.circular(30),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            new Container(
              //刻度(選擇後)
              width: size,
              height: size,
              decoration: new BoxDecoration(
                color: clockTime == (clockType ?? 12) % 12
                    ? Color(0xFFFDF47E)
                    : Color(0xFFFDF47E).withOpacity(0), //Color(0xFFDDC29F),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              //刻度(未選擇)
              width: perW * 10,
              height: perW * 25,
              decoration: new BoxDecoration(
                color: clockTime == (clockType ?? 12) % 12
                    ? Color(0xff75563a).withOpacity(0)
                    : Color(0xff75563a), //Color(0xFFDDC29F),
                shape: BoxShape.rectangle,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: 15,
        height: perW * (230 - 2 * 27 - 16), //220
      ),
      InkWell(
        onTap: () {
          clockTime = clockTime + 6;
          clockTime = switchPM ? clockTime + 12 : clockTime;
          print(clockTime);
          switchBackTime
              ? Provider.of<OutTimeData>(context, listen: false)
                  .editBackTime(clockTime)
              : Provider.of<OutTimeData>(context, listen: false)
                  .editOutTime(clockTime);
          addClockTimeToSF(clockTime, switchBackTime);
          print(
              'backTime: ${Provider.of<OutTimeData>(context, listen: false).backhomeTime}');
          print(
              'outTime: ${Provider.of<OutTimeData>(context, listen: false).outdoorTime}');
        },
        splashColor: Colors.red,
        borderRadius: new BorderRadius.circular(40),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            new Container(
              //刻度(選擇後)
              width: size,
              height: size,
              decoration: new BoxDecoration(
                color: (clockTime + 6) == (clockType ?? 12) % 12
                    ? Color(0xFFFDF47E)
                    : Color(0xFFFDF47E).withOpacity(0), //Color(0xFFDDC29F),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              //刻度(未選擇)
              width: perW * 10,
              height: perW * 25,
              decoration: new BoxDecoration(
                color: (clockTime + 6) == (clockType ?? 12) % 12
                    ? Color(0xff75563a).withOpacity(0)
                    : Color(0xff75563a), //Color(0xFFDDC29F),
                shape: BoxShape.rectangle,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
