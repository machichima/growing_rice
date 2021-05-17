import 'package:flutter/material.dart';

class alarm_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.lightBlueAccent[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: 50,
                        width: 60,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Image(
                            image:
                                AssetImage('assets/images/toolIcon/return.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 100,
                      child: Hero(
                        tag: '鬧鐘',
                        child: Text(
                          '鬧鐘',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Center(
                    child: Text('Hi',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                        )))),
          ],
        ),
      ),
    );
  }
}
