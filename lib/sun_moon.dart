import 'package:flutter/material.dart';
import 'dart:math';

class SunMoon extends StatelessWidget {
  double val;
  int rise;
  int fall;
  String route;
  bool noMoon;
  bool isMoon;
  SunMoon({
    @required this.val,
    @required this.rise,
    @required this.fall,
    @required this.route,
    @required this.isMoon,
    this.noMoon = false,
  });
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (val > fall) val -= 24;
    if (rise > fall && val >= 24) val += 24;
    return noMoon
        ? Container(
            color: Colors.amber.withOpacity(0),
            width: 0,
          )
        : AnimatedPositioned(
            //(pic_width * 4)/(w+pic_width)^2*(x-(l-w)/2)^2      x為left的值
            top: val >= rise
                ? (100 * 4 / pow(100 + w, 2)) *
                        pow(
                            (-100 +
                                    ((val - rise) *
                                        (100 + w) /
                                        (fall - rise).abs())) -
                                (w - 100) / 2,
                            2) +
                    MediaQuery.of(context).padding.top +
                    50
                : 100,
            left: val >= rise
                ? //x
                -100 + ((val - rise) * (100 + w) / (fall - rise).abs())
                : -100,
            //curve: Curves.decelerate,
            duration: val >= fall || val <= rise
                ? Duration(milliseconds: 0)
                : Duration(milliseconds: 100),
            child: Container(
              child: Image.asset(route),
              width: isMoon ? 50 : 100, //picSize
              //color: Colors.blue,
            ),
          );
  }
}
