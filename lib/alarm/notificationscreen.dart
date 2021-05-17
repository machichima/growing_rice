import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  NotificationScreen({this.payload});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  playLocal() async {
    int result = await audioPlayer.play(widget.payload, isLocal: true);
    print('start to play');
  }

  var currenttime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('high'),
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
          child: Container(
            child: Text(
                'alarmfired at ${currenttime.hour} : ${currenttime.minute}'),
            height: 200,
            width: 200,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
