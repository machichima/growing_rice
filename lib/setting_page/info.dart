import 'package:flutter/material.dart';
import 'package:growingrice_withalarm/data/weather_data.dart';
import 'package:provider/provider.dart';

const color1 = Color.fromRGBO(221, 194, 159, 1);

class info_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String skyRoute = Provider.of<WeatherData>(context).skyRoute;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var perH = h / 640;
    var perW = w / 360;
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new ExactAssetImage(
                    skyRoute ?? "assets/images/sky/day.png"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white.withOpacity(0.6),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 0.01 * h,
                  ),
                  Flexible(
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned(
                            left: perW*15,
                            child: InkWell(
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
                          ),
                          Positioned(
                            left: perW*125,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: perH*48,
                              width: perH*100,
                              child: Text(
                                '更多相關資訊',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: perW*44,
                            top: perH*208,
                          child: Container(
                            height: perH*224,
                            width: perW*272,
                            color: Colors.amberAccent,
                            alignment: Alignment.center,
                            child: Container(
                                height: perH*204,
                                width:  perW*252,
                                color: color1,
                                child: Text(
                                  '這裡可以打一些廢話',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.none),
                                )
                            ),
                          ),
                              ),
                          Positioned(
                            left: perW*130,
                            bottom: perH*20,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: perW*200,
                                child: Text('Growing rice',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none)),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}
