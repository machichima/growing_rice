import 'package:flutter/material.dart';

class sheet2 extends StatefulWidget {
  List<String> days;
  List<bool>   opendays;
  sheet2({this.days,this.opendays});
  @override
  _sheet2State createState() => _sheet2State();
}

class _sheet2State extends State<sheet2> {
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
          image: AssetImage('assets/week.png'),
          fit: BoxFit.fill,
        ),
      ),
      onTap: () {
        showModalBottomSheet<void>(
          useRootNavigator: false,
          context: context,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              height: height/2.1,
              color: backgroundcolor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text('開啟日期',style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      widget.days.asMap().entries.map((MapEntry map )=> buttontemplate(index:map.key,value:widget.opendays[map.key],day:widget.days[map.key],opendays:widget.opendays)).toList(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, height/25, 0, 0),
                      child: InkWell(
                        child: Image(
                          image: AssetImage('assets/勾勾.png'),
                          fit: BoxFit.fill,
                        ),
                      onTap: () {
                        //alarms.add(Alarm_look(time: ,enable_task: ,Sunday: ,Monday: ,Tuesday: ,Wednesday: ,Friday: ,Saturday: ));
                        Navigator.pop(context);
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
  }
}
class buttontemplate extends StatefulWidget {
  int index;
  String day;
  List opendays;
  bool value;
  buttontemplate({this.index,this.value,this.day,this.opendays});
  @override
  _buttontemplateState createState() => _buttontemplateState();
}

class _buttontemplateState extends State<buttontemplate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.value);
        setState(() {
          widget.value = !widget.value;
          widget.opendays[widget.index]=widget.value;
        });
      },
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.value ? Colors.green:Colors.grey),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:  Text(
              '${widget.day}'
          ),
        ),
      ),
    );
  }
}
