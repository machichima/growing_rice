import 'package:flutter/material.dart';
import 'outDoorTime.dart';
import 'data.dart';
import 'listlook.dart';
import '../data/weather_data.dart';
import 'package:provider/provider.dart';

const color1 = Color.fromRGBO(221, 194, 159, 1);

class setting_page extends StatefulWidget {
  //String skyRoute;
  //setting_page({@required this.skyRoute});
  @override
  _setting_pageState createState() => _setting_pageState();
}

class _setting_pageState extends State<setting_page> {
  double opacityLevel = 0;

  Widget cardtemplete(settinglook settingdata, context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: Card(
        color: color1,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Container(
          height: 60,
          child: ListTile(
            leading:
                SizedBox(width: 40, child: Center(child: settingdata.lookicon)),
            title: Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
              child: Text(settingdata.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )),
            onTap: () {
              // if (settingdata.route == '/goout') {
              //   Navigator.of(context).push(
              //     PageRouteBuilder(
              //       //opaque: false, // set to false
              //       pageBuilder: (_, __, ___) => OutDoorTime(),
              //     ),
              //   );
              // } else {
              print(settingdata.route);
              Navigator.pushNamed(context, settingdata.route);
              // }
            },
          ),
        ),
      ),
    );
  }

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  void initState() {
    super.initState();
    setState(() {
      _changeOpacity();
    });
  }

  @override
  Widget build(BuildContext context) {
    String skyRoute = Provider.of<WeatherData>(context).skyRoute;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var perH = h / 640;
    var perW = w / 360;
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new ExactAssetImage(skyRoute ?? "assets/images/sky/day.png"),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //   Colors.white.withOpacity(1.0),
            //   BlendMode.color,
            // ),
          ),
        ),
        alignment: Alignment.topCenter,
        //color: Colors.lightBlueAccent[100],
        height: double.infinity,
        child: Container(
          color: Colors.white.withOpacity(0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 0.01 * h),
              Row(
                children: [
                  SizedBox(width: perW * 15),
                  InkWell(
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
                  SizedBox(
                    width: perW * 70,
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      //height: 60,
                      width: 100,
                      child: Text(
                        '設定',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: Duration(seconds: 1),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: datas
                          .map((element) => cardtemplete(element, context))
                          .toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
