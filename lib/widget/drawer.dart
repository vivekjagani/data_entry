import 'package:data_entry/screens/add_data_screen.dart';
import 'package:data_entry/screens/all_task.dart';
import 'package:data_entry/screens/daily_task.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, DailyTask.routeName);
            },
            child: const ListTile(
              title: Text('Daily Task'),
            ),
          ),
          GestureDetector(
            child: const ListTile(
              title: Text('All Task'),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, AllTask.routeName);
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, AddDataScreen.routeName);
            },
            child: const ListTile(
              title: Text('Add Task'),
            ),
          )
        ],
      ),
    );
  }
}
