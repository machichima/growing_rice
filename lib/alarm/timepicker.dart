import 'flutter_time_picker_spinner.dart';
import 'package:flutter/material.dart';

typedef void timecallback(DateTime temptime);


class alarmtimepicker extends StatelessWidget {
  DateTime dateTime ;
  final timecallback onsonchanged;
  alarmtimepicker({this.onsonchanged,this.dateTime});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            alignment:Alignment.center,
            width: 250,
            color: Colors.brown[300],
            child: TimePickerSpinner(
              time: dateTime,
              is24HourMode: true,
              normalTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
              highlightedTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
              spacing: 20,
              itemHeight: 30,
              isForce2Digits: true,
              minutesInterval: 1,
              onTimeChange: (time) {
                print(time.toString());
                onsonchanged(time);
              },
            ),
          ),
        )
    );
  }
}
