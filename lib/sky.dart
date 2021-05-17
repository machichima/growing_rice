import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './data/weather_data.dart';

class Sky extends StatefulWidget {
  double val;
  int sunRise;
  int sunFall;
  String route;
  Sky({this.val, this.sunRise, this.sunFall, this.route});

  @override
  _SkyState createState() => _SkyState();
}

class _SkyState extends State<Sky> {
  @override
  Widget build(BuildContext context) {
    if (widget.val >= 24) {
      widget.val -= 24;
      print(widget.val);
    }
    return AnimatedPositioned(
      //sky
      child: Container(
        child: Image.asset(
          widget.route,
          fit: BoxFit.fill,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
      top: 0,
      left: 0,
      duration: Duration(milliseconds: 50),
    );
  }
}
