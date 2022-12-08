// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class NotificationService with ChangeNotifier {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

 

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required bool isActive,
    required String date,
    required String time,
  }) async {
    //date....
    var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    debugPrint('CHECK : ${currentDate.toString()}');
    //time....
    var ttime = TimeOfDay.now();
    DateTime tempDate =
        DateFormat("hh:mm").parse("${ttime.hour}:${ttime.minute}");
    var currentTime = DateFormat("h:mm a").format(tempDate);
    debugPrint(currentTime);

    try {
      if (currentDate == date && currentTime == time) {
        await flutterLocalNotificationsPlugin.schedule(
          id,
          title,
          body,
          DateTime.now(),
          NotificationDetails(
            android: AndroidNotificationDetails(
              'data',
              'data',
              importance: Importance.max,
              playSound: isActive,
              color: Colors.red,
              sound:
                  const UriAndroidNotificationSound("asset/notification.mp3"),
              priority: Priority.high,
            ),
          ),
          androidAllowWhileIdle: true,
        );
      } else {
        debugPrint("can't match");
      }
    } catch (e) {
      debugPrint('===>ERROR : ${e.toString()}');
    }
  }

  void notificationDemo(){
    //....Notification...
  }
}
