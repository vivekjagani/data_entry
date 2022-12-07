import 'dart:ffi';

import 'package:data_entry/models/task.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';

class TaskData with ChangeNotifier {
  List<Task> taskData = [];

  List<Task> get taskList {
    return [...taskData];
  }

  Future<void> addTaskData({name, date, time, alertMe}) async {
    debugPrint('===> : name : $name');
    debugPrint('===> : date : $date');
    debugPrint('===> : time : $time');
    debugPrint('===> : alertMe : $alertMe');

    await DatabaseHelper.insert('taskData', {
      'task': name,
      'date': date,
      'time': time,
      'isAlert': alertMe,
    });
    notifyListeners();
  }

  Future<List> getAndSetTask() async {
    taskData.clear();
    var dbQuery = await DatabaseHelper.getData('taskData');
    debugPrint(dbQuery.toString());

    dbQuery.map((task) {
      bool data = (task['isAlert'] == 1);
      debugPrint('===> task : ${task['task']}');
      debugPrint('===> date : ${task['date']}');
      debugPrint('===> time : ${task['time']}');
      debugPrint('===> IsAlert : $data');
      taskData.add(
        Task(
          name: task['task'],
          date: task['date'],
          time: task['time'],
          alertMe: data,
        ),
      );
    }).toList();

    notifyListeners();
    return dbQuery;
  }

  Future updateTask({required String task, required bool isAlert}) async {
    await DatabaseHelper.updateTask('taskData', {'isAlert': isAlert}, task);
  }

  Future deleteTask(String task) async {
    await DatabaseHelper.deleteData(table: 'taskData', task: task);
    taskData.removeWhere(
      (task) => task.name == task,
    );
  }
}
