
import 'package:flutter/material.dart';
import 'NotificationPlugin.dart';
import 'alarmsheet.dart';
import 'alarm_look.dart';

class alarmcard extends StatefulWidget {
    Alarm_look alarm;
  alarmcard({this.alarm});
  @override
  _alarmcardState createState() => _alarmcardState();
}
final Color backgroundcolor = Color.fromRGBO(232, 244, 253, 100);
const dates = ['一', '二', '三', '四', '五', '六', '日'];

class _alarmcardState extends State<alarmcard> {

  var currenttime=DateTime.now();
  var Date;

  @override
  void initState() {
    checkdays();
    super.initState();
  }

    void checkdays(){
      Date=[widget.alarm.Monday,widget.alarm.Tuesday,widget.alarm.Wednesday,widget.alarm.Thursday,widget.alarm.Friday,widget.alarm.Saturday,widget.alarm.Sunday,];
        if (widget.alarm.isactive && Date[currenttime.weekday-1]) {
          notificationPlugin.scheduleNotification(widget.alarm.alarm_time,
              widget.alarm.id,widget.alarm.sound);}
        else {
          notificationPlugin.cancelNotification(widget.alarm.id);
        }
    }
    void resetalarm(){
    setState(() {
      print('setstate');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return InkWell(
      onTap: (){
        alarmsheet(context,widget.alarm,resetalarm);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        color: Colors.orange[200],
        child: Container(
          width: width/1.2,
          height: height/9.6,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: width/18.95,
                child: Container(
                    child: Image(
                      image: widget.alarm.enable_task ? AssetImage('assets/mission_flag2.2.png'):AssetImage('assets/mission_flag1.2.png'),
                      fit: BoxFit.fill,
                    )
                ),
              ),
              Positioned(
                top: 0,
                left: width/6,
                child: Container(
                  width: width/3,
                  height: height/16,
                  child: Text('${widget.alarm.alarm_time.hour.toString().padLeft(2, '0')}:${widget.alarm.alarm_time.minute.toString().padLeft(2, '0')} ', style: TextStyle(fontSize: 40),),
                ),
              ),
              Positioned(
                bottom: height/139.13,
                left: width/15,
                child: Container(
                  height: height/42.6667,
                  width: width/2,
                  child: Daterow(alarm: widget.alarm,width: width,height: height,),
                ),
              ),
              Positioned(
                top: height/27.82,
                right: width/32.73,
                child: Container(
                  height: height/25.6,
                  width: width/7,
                    child: Switch(
                      value: widget.alarm.isactive,
                      onChanged: (value) {
                        setState((){
                          widget.alarm.isactive = value;
                          print(widget.alarm.isactive);
                          checkdays();
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Daterow extends StatelessWidget {
  final Alarm_look alarm;
  final List<bool> dayEnable;
  var width;
  var height;
  Daterow({Key key, this.alarm,this.width,this.height}) : dayEnable = [
    alarm.Monday,
    alarm.Tuesday,
    alarm.Wednesday,
    alarm.Thursday,
    alarm.Friday,
    alarm.Saturday,
    alarm.Sunday,
  ],super(key: key);

  Widget alarmday(String day){
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: width/45),
      width: width/24,
      height: height/42.667,
      decoration: BoxDecoration(
        color:Colors.white,
        shape: BoxShape.circle,
      ),
      child: Text(day,style:TextStyle(fontSize: 10,fontWeight: FontWeight.bold) ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        dayEnable[0] ? alarmday(dates[0]) : SizedBox(),
        dayEnable[1] ? alarmday(dates[1]) : SizedBox(),
        dayEnable[2] ? alarmday(dates[2]) : SizedBox(),
        dayEnable[3] ? alarmday(dates[3]) : SizedBox(),
        dayEnable[4] ? alarmday(dates[4]) : SizedBox(),
        dayEnable[5] ? alarmday(dates[5]) : SizedBox(),
        dayEnable[6] ? alarmday(dates[6]) : SizedBox(),
      ],
    );
  }
}

class Alarmscreen extends StatelessWidget {
  String payload;

  Alarmscreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}