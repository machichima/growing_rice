import 'package:flutter/material.dart';
import 'package:growingrice_withalarm/data/weather_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const color1 = Color.fromRGBO(221, 194, 159, 1);
const _url = 'https://forms.gle/dczdFDU9WQ9CfsTC8';

class info_page extends StatelessWidget {

  void _launchURL() async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

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
                            left: perW*60,
                            child: Container(
                              alignment: Alignment.center,
                              height: perH*48,
                              width: perH*200,
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
                            left: perW*29,
                            top: perH*168,
                          child: Container(
                            height: perH*304,
                            width: perW*302,
                            color: Colors.amberAccent,
                            alignment: Alignment.center,
                            child: Container(
                                height: perH*284,
                                width:  perW*282,
                                color: color1,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Text(
                                    "   Growing rice這款軟體希望能讓使用者在每天解鬧鐘的過程中，便能知道當天的天氣，省去查找天氣的困擾!"
                                  "利用圖形化的表達方式，讓使用者查找天氣更為便利!"
                                  "若在使用上遇到問題，歡迎至PLAY商店留言告訴我們，或是點選下方'Growing Rice'進入google表單給我們回饋!\n\n"

                                  "   開發者團隊:"
                                  "此程式由第一屆智慧自動化工程科之學生:葉乃瑞、朱彥勳、劉茂德、蕭禹陞、謝紫翎、蕭佩姍等人於2021年六月共同開發完成,",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none),
                                  ),
                                )
                            ),
                          ),
                              ),
                          Positioned(
                            left: perW*110,
                            bottom: perH*20,
                              child: FlatButton(
                                onPressed: _launchURL,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: perW*200,
                                  child: Text('Growing Rice',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.none)),
                                ),
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
