import 'package:flutter/cupertino.dart';

class Task with ChangeNotifier {
  String name;
  String date;
  String time;
  bool alertMe;

  Task({
    required this.name,
    required this.date,
    required this.time,
    required this.alertMe,
  });

  // toggleSwitch() {
  //   alertMe = !alertMe;
  //   notifyListeners();
  // }
}
