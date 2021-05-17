import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';

class WeatherIcon extends StatelessWidget {
  String iconTypeName;
  var iconType;
  var val_12;
  var sunRise;
  var sunFall;
  WeatherIcon({
    @required this.iconTypeName,
    @required this.iconType,
    @required this.val_12,
    @required this.sunRise,
    @required this.sunFall,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var perW = w / 360;
    var perH = h / 640;
    return Row(
      //降雨機率
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          //width: 40,
          //height: 40,
          child: Image.asset(
            'assets/images/weatherIcon/$iconTypeName.png',
            width: perW * 20,
            height: perW * 30,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5, left: 1),
          child: Text(
            iconTypeName == 'precipprob'
                ? '$iconType%'
                : iconTypeName == 'temp' || iconTypeName == 'feelTemp'
                    ? '$iconType℃'
                    : '$iconType',
            style: TextStyle(
                color: val_12 > sunRise && val_12 < sunFall
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
      ],
    );
  }
}
