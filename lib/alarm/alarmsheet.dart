import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'NotificationPlugin.dart';
import 'alarm_look.dart';
import 'sheet2.dart';
import 'timepicker.dart';

void alarmsheet(context,Alarm_look alarm,loadAlarm){
  final Color backgroundcolor = Color.fromRGBO(232, 244, 253, 100);
  List<String> days=['一','二','三','四','五','六','日'];
  List<bool>   opendays=[false,false,false,false,false,false,false,];
  List<bool>  setdays=[false,false,false,false,false,false,false,];
  String sound;
  bool enable;
  var Date;
  var currenttime=DateTime.now();
  var selectedTime;

    selectedTime=alarm.alarm_time;
    enable=alarm.enable_task;
    sound=alarm.sound;
    opendays[6]=alarm.Sunday;
    opendays[0]=alarm.Monday;
    opendays[1]=alarm.Tuesday;
    opendays[2]=alarm.Wednesday;
    opendays[3]=alarm.Thursday;
    opendays[4]=alarm.Friday;
    opendays[5]=alarm.Saturday;

  void settingdays() {
    for (int i = 0; i < 7; i++) {
      setdays[i]=opendays[i];
    }
  }
  void checkdays(){
    Date=[alarm.Monday,alarm.Tuesday,alarm.Wednesday,alarm.Thursday,alarm.Friday,alarm.Saturday,alarm.Sunday,];
    if (alarm.isactive && Date[currenttime.weekday-1]) {
      notificationPlugin.scheduleNotification(alarm.alarm_time,
          alarm.id,alarm.sound);}
    else {
      notificationPlugin.cancelNotification(alarm.id);
    }
  }
  void updatetime(DateTime newtime){
    selectedTime = newtime;
  }
  final size =MediaQuery.of(context).size;
  final width =size.width;
  final height =size.height;

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
                            Container(
                              height: width/6,
                              width: width/6,
                              child: InkWell(
                                onTap: () async {
                                  FilePickerResult result = await FilePicker.platform.pickFiles(
                                      type: FileType.audio
                                  );
                                  if(result != null) {
                                    File file2 = File(result.files.single.path);
                                    sound = file2.toString();
                                    print(sound);
                                  } else {
                                    // User canceled the picker
                                  }},
                                child: Image(
                                  image: AssetImage('assets/檔案_001.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, height/20, 0, 0),
                      child: InkWell(
                          child: Image(
                            image: AssetImage('assets/勾勾.png'),
                            fit: BoxFit.fill,
                          ),
                          onTap: () {
                            print(selectedTime);
                            alarm.sound=sound;
                            alarm.alarm_time=selectedTime;
                            alarm.enable_task=enable;
                            alarm.sound=sound;
                            alarm.Sunday=setdays[6];
                            alarm.Monday=setdays[0];
                            alarm.Tuesday=setdays[1];
                            alarm.Wednesday=setdays[2];
                            alarm.Thursday=setdays[3];
                            alarm.Friday=setdays[4];
                            alarm.Saturday=setdays[5];
                            loadAlarm();
                            checkdays();
                            Navigator.pop(context);
                          }
                      ),
                    )
                  ],
                ),
              ),
            );}
      );
    },
  );
}
