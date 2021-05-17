import 'package:flutter/material.dart';

class sheet3 extends StatefulWidget {
  List alarmbool;
  String sound;
  sheet3({this.sound,this.alarmbool});
  @override
  _sheet3State createState() => _sheet3State();
}

class _sheet3State extends State<sheet3> {
  @override
  Widget build(BuildContext context) {
    final Color backgroundcolor = Color.fromRGBO(232, 244, 253, 100);
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return InkWell(
      child: Container(
        height: width/6,
        width: width/6,
        alignment: Alignment.center,
        child: Image(
          image: AssetImage('assets/檔案_001.png'),
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {
        print(widget.sound);
        if(widget.sound=='alarm1'){
         widget.alarmbool[0]=true;
        }
        else if(widget.sound=='alarm2'){
          widget.alarmbool[1]=true;
        }
        else if(widget.sound=='alarm3'){
          widget.alarmbool[2]=true;
        }
        showModalBottomSheet<void>(
          useRootNavigator: true,
          context: context,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder:(context,setModalState){
              return Container(
                height: height/2.1,
                color: backgroundcolor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('選擇鈴聲',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                      ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: width/9),
                      child: FlatButton(
                        onPressed: (){
                          setModalState(() {
                            if (widget.alarmbool[1]|widget.alarmbool[2]==true){
                              widget.alarmbool[0]=!widget.alarmbool[0];
                              widget.sound='alarm1';
                              print(widget.sound);
                            }
                            if (widget.alarmbool[0]){
                              widget.alarmbool[1]=false;
                              widget.alarmbool[2]=false;
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: widget.alarmbool[0]? Colors.grey[800]:Colors.indigo[50],
                          height: height/25,
                          child: Text('alarm1',),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: width/9),
                      child: FlatButton(
                        onPressed: (){
                          setModalState(() {
                            if (widget.alarmbool[0]|widget.alarmbool[2]==true){
                              widget.alarmbool[1]=!widget.alarmbool[1];
                              widget.sound='alarm2';
                              print(widget.sound);
                            }
                            if (widget.alarmbool[1]){
                              widget.alarmbool[0]=false;
                              widget.alarmbool[2]=false;
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: widget.alarmbool[1]? Colors.grey[800]:Colors.indigo[50],
                          height: height/25,
                          child: Text('alarm2',),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal:width/9),
                      child: FlatButton(
                        onPressed: (){
                          setModalState(() {
                            if (widget.alarmbool[0]|widget.alarmbool[1]==true){
                              widget.alarmbool[2]=!widget.alarmbool[2];
                              widget.sound='alarm3';
                              print(widget.sound);
                            }
                            if (widget.alarmbool[2]){
                              widget.alarmbool[1]=false;
                              widget.alarmbool[0]=false;
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: widget.alarmbool[2]? Colors.grey[800]:Colors.indigo[50],
                          height: height/25,
                          child: Text('alarm3',),
                        ),
                      ),
                    ),
                  ],
                ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, height/15, 0, 0),
                        child: InkWell(
                          child: Image(
                            image: AssetImage('assets/勾勾.png'),
                            fit: BoxFit.fill,
                          ),
                        onTap: () {
                            if(widget.alarmbool[0]){
                              widget.sound='alarm1';
                            }
                            else if(widget.alarmbool[1]){
                              widget.sound='alarm2';
                            }
                            else if(widget.alarmbool[2]){
                                widget.sound='alarm3';
                              }

                            print(widget.sound);
                          //alarms.add(Alarm_look(time: ,enable_task: ,Sunday: ,Monday: ,Tuesday: ,Wednesday: ,Friday: ,Saturday: ));
                          Navigator.pop(context,widget.sound);
                        } ,
                      ),
                      )
                    ],
                  ),
                ),
              );
              },
            );
          },
        );
      },
    );
  }
}

class Music extends StatefulWidget {
  bool alarm1;
  bool alarm2;
  bool alarm3;
  String music;
  var height;
  var width;
  Music({this.width,this.height,this.alarm3,this.alarm1,this.alarm2,this.music});
  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: widget.width/9),
          child: InkWell(
            onTap: (){
              setState(() {
                if (widget.alarm2|widget.alarm3==true){
                  widget.alarm1=!widget.alarm1;
                  widget.music='alarm1';
                  print(widget.music);
                }
                if (widget.alarm1){
                  widget.alarm2=false;
                  widget.alarm3=false;
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              color: widget.alarm1? Colors.grey[800]:Colors.indigo[50],
              height: widget.height/25,
              child: Text('alarm1',),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: widget.width/9),
          child: InkWell(
            onTap: (){
              setState(() {
                if (widget.alarm1|widget.alarm3==true){
                  widget.alarm2=!widget.alarm2;
                  widget.music='alarm2';
                  print(widget.music);
                }
                if (widget.alarm2){
                  widget.alarm1=false;
                  widget.alarm3=false;
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              color: widget.alarm2? Colors.grey[800]:Colors.indigo[50],
              height: widget.height/25,
              child: Text('alarm2',),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10,horizontal:widget.width/9),
          child: InkWell(
            onTap: (){
              setState(() {
                if (widget.alarm2|widget.alarm1==true){
                  widget.alarm3=!widget.alarm3;
                  widget.music='alarm3';
                  print(widget.music);
                }
                if (widget.alarm3){
                  widget.alarm2=false;
                  widget.alarm1=false;
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              color: widget.alarm3? Colors.grey[800]:Colors.indigo[50],
              height: widget.height/25,
              child: Text('alarm3',),
            ),
          ),
        ),
      ],
    );
  }
}
