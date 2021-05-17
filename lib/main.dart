import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:growingrice_withalarm/alarm/alarm_main.dart';
import 'main_page.dart';
import './data/weather_data.dart';
import 'package:provider/provider.dart';
import './data/outTimeProvider.dart';
import './setting_page/setting.dart';
import './setting_page/alarm.dart';
//import './alarm/alarm_main.dart';
import './setting_page/weather.dart';
import './setting_page/outDoorTime.dart';
import './setting_page/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: WeatherData(),
        ),
        ChangeNotifierProvider.value(
          value: OutTimeData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/mainPage': (context) => MainPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/setting': (context) => setting_page(),
          '/alarm': (context) => MyAlarm(),
          '/weather': (context) => weather_page(),
          '/goout': (context) => OutDoorTime(),
          '/info': (context) => info_page(),
        },
        home: MyHome(),
      ),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MainPage());
  }
}

// Container Block() {
//   return Container(
//     child: Row(
//       children: [
//         Container(
//           color: Colors.green,
//           width: 50,
//           height: 200,
//         ),
//       ],
//       mainAxisAlignment: MainAxisAlignment.end,
//     ),
//     height: double.infinity,
//   );
// }

// AnimatedBuilder(
//               animation: _controller,
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 child: Scale(),
//               ),
//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: angle,
//                   child: child,
//                 );
//               },
//             ),
