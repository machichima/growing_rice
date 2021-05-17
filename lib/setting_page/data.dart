import 'listlook.dart';
import 'package:flutter/material.dart';


List<settinglook> datas=[
  settinglook(
      lookicon:Icon(Icons.alarm),
      title:'鬧鐘',
      route:'/alarm'
  ),
  settinglook(
      lookicon:Icon(Icons.sensor_door),
      title:'外出時間設定',
      route:'/goout'
  ),
  settinglook(
      lookicon:Icon(Icons.settings_sharp),
      title:'天氣資訊設定',
      route:'/weather'
  ),
  settinglook(
      lookicon:Icon(Icons.info),
      title:'更多相關資訊',
      route:'/info'
  ),
];