import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

bool _isSwitched = false;

void main() {
  runApp(Clock());
}

// MyApp is a StatefulWidget. This allows updating the state of the
// widget when an item is removed.
class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  ClockState createState() {
    return ClockState();
  }
}

class ClockState extends State<Clock> {
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    final title = '鬧鐘';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemExtent: 100.0,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(item),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    items.removeAt(index);
                  });

                  // Then show a snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("$item dismissed")));
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: MyStatefulWidget('$item'));
          },
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget(String s, {Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            color: Colors.lightBlueAccent,
            child: ListTile(
                title: Text(
                  '8:00',
                  style: TextStyle(fontSize: 40),
                ),
                subtitle: Text('一 二 三 四 五 六 日', style: TextStyle(height: 3)),
                dense: false,
                leading: const Icon(Icons.alarm),
                trailing: Container(
                  width: 100,
                  child: Center(
                    child: Switch(
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = value;
                          print(_isSwitched);
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ),
                ))));
  }
}
