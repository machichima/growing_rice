
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'alarm_helper.dart';
import 'package:flutter/material.dart';
import 'alarm_look.dart';
import 'sheet2.dart';
import 'sheet3.dart';
import 'timepicker.dart';


class sheet extends StatefulWidget {
  Function loadAlarm;
  AlarmHelper alarmHelper;
  sheet({this.alarmHelper,this.loadAlarm});

  @override
  _sheetState createState() => _sheetState();

}

class _sheetState extends State<sheet> {

  final Color backgroundcolor = Color.fromRGBO(232, 244, 253, 100);
  List<String> days=['一','二','三','四','五','六','日'];
  List<bool>   opendays=[true,true,true,true,true,true,true,];
  List<bool>  setdays=[false,false,false,false,false,false,false,];
  List<bool> alarmbool=[false,false,false];
  String sound='alarm1';
  bool enable_task=true;
  bool enable=true;
  DateTime initialtime=DateTime.now();
  var selectedTime;

  void settingdays() {
    enable=enable_task;
    for (int i = 0; i < 7; i++) {
      setdays[i]=opendays[i];
    }
    selectedTime=initialtime;
  }

  void updatetime(DateTime newtime){
    setState(() {
      selectedTime = newtime;
    });
  }

  @override

  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;

    return Container(
      height: width/7.06,
      width: width/7.06,
      child: InkWell(
        child: Image(
          image: AssetImage('assets/加號.png'),
          fit: BoxFit.fill,
        ),
        onTap: () {
          initialtime=DateTime.now();
          settingdays();
          showModalBottomSheet(
            useRootNavigator: true,
            context: context,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            builder: (BuildContext context) {
              return StatefulBuilder(
                  builder: (context,setModalState){
                    return Container(
                        height: height/2.1,
                        color: backgroundcolor,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                alarmtimepicker(onsonchanged: (DateTime newtime){
                                  updatetime(newtime);
                                },dateTime: selectedTime,)
                                ,
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, height/20, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          child: Container( height:width/6,width: width/6 ,child: enable ? Image(image: AssetImage('assets/task.png'), fit: BoxFit.fill,): Image(image: AssetImage('assets/task無底色.png'), fit: BoxFit.fill,),),
                                          onTap: (){
                                            setModalState(() {
                                              enable=!enable;
                                            });}
                                      ),
                                      Container(
                                        child:
                                        sheet2(days: days,opendays: setdays,),
                                      ),
                                      Container(
                                        child:
                                        sheet3(sound: sound,alarmbool: alarmbool,),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, height/18, 0, 0),
                                  child: InkWell(
                                      child: Image(
                                        image: AssetImage('assets/勾勾.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      onTap: () {
                                        print(selectedTime);
                                        print(sound);
                                        var tempalarm=Alarm_look(alarm_time: selectedTime,enable_task: enable,sound: sound,isactive: true,Sunday: setdays[6],Monday: setdays[0],Tuesday: setdays[1],Wednesday: setdays[2],Thursday: setdays[3],Friday: setdays[4],Saturday: setdays[5]);
                                        widget.alarmHelper.insertAlarm(tempalarm);
                                        widget.loadAlarm();
                                        Navigator.pop(context);
                                      }
                                  ),
                                ),]
                          ),
                        ));
                  }
              );
            },
          );
        },
      ),
    );
  }
}


