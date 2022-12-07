import 'dart:async';

import 'package:data_entry/screens/daily_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/notification_api.dart';
import '../models/task_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  task() {
    var taskData = Provider.of<TaskData>(context, listen: false).taskData;
    // Date....
    var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    //time....
    var ttime = TimeOfDay.now();
    DateTime tempDate =
        DateFormat("hh:mm").parse("${ttime.hour}:${ttime.minute}");
    var currentTime = DateFormat("h:mm a").format(tempDate);

    var title;
    var body;
    var isActive;
    var date;
    var time;
    var element;
    debugPrint(taskData.toString());

    try {
      for (element in taskData) {
        debugPrint('===>${element.date}');
        debugPrint(element.name);
        debugPrint(element.time);
        debugPrint(element.alertMe.toString());

        if (element.date == currentDate && element.time == currentTime) {
          title = element.name;
          body = element.time;
          isActive = element.alertMe;
          date = element.date;
          time = element.time;

          NotificationService().showNotification(
            id: 1,
            title: title,
            body: body,
            isActive: isActive,
            date: date,
            time: time,
          );
        }
      }
    } catch (e) {
      debugPrint("ERROR : ${e.toString()}");
    }
  }

  @override
  void initState() {
    try {
      Timer(const Duration(seconds: 2),
          () => Navigator.pushNamed(context, DailyTask.routeName));
      task();
      Timer.periodic(const Duration(minutes: 1), (Timer timer) {
        task();
      });
    } catch (e) {
      debugPrint('ERROR : ${e.toString()}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
