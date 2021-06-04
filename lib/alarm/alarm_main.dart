import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:growingrice_withalarm/data/weather_data.dart';
import 'package:provider/provider.dart';
import 'NotificationPlugin.dart';
import 'alarm_helper.dart';
import 'notificationscreen.dart';
import 'sheet.dart';
import 'alarm_look.dart';
import 'alarmcard.dart';

void main() async {
  runApp(material());
}

class material extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAlarm(),
    );
  }
}

class MyAlarm extends StatefulWidget {
  @override
  _MyAlarmState createState() => _MyAlarmState();
}

class _MyAlarmState extends State<MyAlarm> {
  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<Alarm_look>> _alarms;
  List<Alarm_look> _currentAlarms;

  @override

  /**從這行
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

  **/

  //到這行，為設定鬧種嚮的頁面;
  void initState() {
    /**
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    **/
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
      print(_alarms);
    });
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    String skyRoute = Provider.of<WeatherData>(context).skyRoute;
    debugPaintSizeEnabled = false;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new ExactAssetImage(
                skyRoute ?? "assets/images/sky/day.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          color: Colors.white.withOpacity(0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topLeft,
                height: height / 6.4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).padding.top + width / 20,
                      left: width / 24,
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: height/17.297,
                            width: width/7.5,
                            child: Image(
                              image: AssetImage("assets/images/toolIcon/return.png"),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + width / 20,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '鬧鐘',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: alarm_Listview(
                  alarmHelper: _alarmHelper,
                  alarms: _alarms,
                  currentAlarms: _currentAlarms,
                  loadAlarms: loadAlarms,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, height / 18),
                  child: Center(
                      child: sheet(
                    alarmHelper: _alarmHelper,
                    loadAlarm: loadAlarms,
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}

class alarm_Listview extends StatefulWidget {
  Future<List<Alarm_look>> alarms;
  List<Alarm_look> currentAlarms;
  AlarmHelper alarmHelper;
  Function loadAlarms;
  alarm_Listview(
      {this.alarmHelper, this.alarms, this.currentAlarms, this.loadAlarms});
  @override
  _alarm_ListviewState createState() => _alarm_ListviewState();
}

class _alarm_ListviewState extends State<alarm_Listview> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Container(
      child: FutureBuilder<List<Alarm_look>>(
          future: widget.alarms,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              widget.currentAlarms = snapshot.data;
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var alarm = snapshot.data[index];
                    String time =
                        '${alarm.alarm_time.hour.toString().padLeft(2, '0')}:${alarm.alarm_time.minute.toString().padLeft(2, '0')}';
                    return Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: Key(alarm.id
                            .toString()), //每一個Dismissible都必須有專屬的key，讓Flutter能夠辨識
                        onDismissed: (direction) {
                          //項目移除後要做什麼事
                          setState(() {
                            //從data中移除項目
                            notificationPlugin.cancelNotification(alarm.id);
                            snapshot.data.removeAt(index);
                            widget.loadAlarms();
                          });
                        },
                        confirmDismiss: (diration) async {
                          return await widget.alarmHelper.delete(alarm.id) == 1
                              ? true
                              : false;
                        },
                        background: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.red,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(width / 20, 0, 0, 0),
                              child: Image(
                                image: AssetImage('assets/垃圾桶_黑.png'),
                                fit: BoxFit.fitHeight,
                              ),
                              width: width / 1.2,
                              height: height / 9.6),
                        ), //滑動時跑出來的背景色
                        child: Center(
                          child: alarmcard(
                            alarm: alarm,
                          ),
                        ));
                  });
            } else
              return Center(
                child: Text('hi'),
              );
          }),
    );
  }

  void showMySnackBar(BuildContext context, index, alarm) {
    String time =
        '${alarm.alarm_time.hour.toString().padLeft(2, '0')}:${alarm.alarm_time.minute.toString().padLeft(2, '0')}';
    final snackBar = new SnackBar(
        content: new Text('$time的鬧鐘將被刪除'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
            label: '還原',
            onPressed: () {
              setState(() {
                widget.alarmHelper.insertAlarm(alarm);
              });
            }));

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
