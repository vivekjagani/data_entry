import 'package:data_entry/models/task_data.dart';
import 'package:data_entry/screens/all_task.dart';
import 'package:data_entry/screens/daily_task.dart';
import 'package:data_entry/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/notification_api.dart';
import 'screens/add_data_screen.dart';

//snehal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskData>(
          create: (_) => TaskData(),
        ),
        ChangeNotifierProvider<NotificationService>(
          create: (_) => NotificationService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
        routes: {
          DailyTask.routeName:(context) => const DailyTask(),
          AddDataScreen.routeName: (context) => const AddDataScreen(),
          AllTask.routeName: (context) => const AllTask(),
        },
      ),
    );
  }
}
