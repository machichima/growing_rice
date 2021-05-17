import 'package:flutter/material.dart';



class goout_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      height: 50,
                      width: 60,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Image(
                          image: AssetImage('assets/back.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 200,
                    child: Hero(
                      tag:'外出時間設定',
                      child: Text(
                        '外出時間設定',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black,decoration:TextDecoration.none, ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child:  Center(
                  child:Text('Hi',style:TextStyle(decoration:TextDecoration.none,))
              )
          ),

        ],
      ),
    );
  }
}