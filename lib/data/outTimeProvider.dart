import 'package:flutter/material.dart';

class OutTimeData extends ChangeNotifier {
  int outdoorTime;
  int backhomeTime;

  void editOutTime(int outTime) {
    this.outdoorTime = outTime;
    notifyListeners();
  }

  void editBackTime(int backTime) {
    this.backhomeTime = backTime;
    notifyListeners();
  }
}
