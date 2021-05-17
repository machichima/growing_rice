import 'package:flutter/material.dart';

const color1 = Color.fromRGBO(221, 194, 159, 1);

class info_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var perH = h / 640;
    var perW = w / 360;
    return Material(
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.lightBlueAccent[100],
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
                SizedBox(width: perW * 50),
                Expanded(
                  child: Container(
                    //alignment: Alignment.center,
                    //height: 60,
                    //width: 100,
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
              ],
            ),
            Expanded(
                child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.amberAccent,
                  alignment: Alignment.center,
                  child: Container(
                      padding: EdgeInsets.all(8),
                      color: color1,
                      child: Text(
                        '這裡可以打一些廢話',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none),
                      )),
                ),
                Expanded(
                  flex: 7,
                  child: SizedBox(),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Text('Growing rice',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.none)),
                    ))
              ],
            )),
          ],
        ),
      ),
    );
  }
}
