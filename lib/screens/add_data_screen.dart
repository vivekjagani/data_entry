import 'package:data_entry/models/database_helper.dart';
import 'package:data_entry/models/task_data.dart';
import 'package:data_entry/widget/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddDataScreen extends StatefulWidget {
  static const routeName = '/add-data';

  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var formattedDate;
  var formattedTime;
  bool isAlert = false;

  Future<void> selectDate() async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));

    formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate as DateTime);
    dateController.text = formattedDate.toString();
  }

  Future<TimeOfDay?> selectTime() async {
    try {
      var pickedTime = await showTimePicker(
        context: context,
        cancelText: 'cancle',
        confirmText: 'Ok',
        initialTime: TimeOfDay.now(),
      );
      formattedTime = pickedTime?.format(context);

      timeController.text = formattedTime.toString();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void toggleSwitch(bool value) {
    if (isAlert == false) {
      setState(() {
        isAlert = true;
        debugPrint('IsAlert : $isAlert');
      });
    } else {
      setState(() {
        isAlert = false;
        debugPrint('IsAlert : $isAlert');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> saveForm() async {
      _form.currentState?.validate();
    
      await Provider.of<TaskData>(
        context,
        listen: false,
      )
          .addTaskData(
            
        date: dateController.text,
        name: taskController.text,
        alertMe: isAlert,
        time: timeController.text,
      )
          .then(
        (value) {
          taskController.clear();
          dateController.clear();
          timeController.clear();
          setState(() {
            isAlert = false;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
      ),
      drawer: const MyDrawer(),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: taskController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please provide the Task';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Enter task', label: Text('task')),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please select the Date';
                  }
                  return null;
                },
                controller: dateController,
                onTap: selectDate,
                decoration: const InputDecoration(hintText: 'select date'),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please select the time';
                  }
                  return null;
                },
                controller: timeController,
                decoration: const InputDecoration(hintText: 'select time'),
                onTap: selectTime,
              ),
              Row(
                children: [
                  const Text('Alert Me : '),
                  CupertinoSwitch(
                      value: isAlert,
                      thumbColor: CupertinoColors.systemBlue,
                      trackColor: CupertinoColors.systemRed.withOpacity(0.14),
                      activeColor: CupertinoColors.systemRed.withOpacity(0.64),
                      onChanged: toggleSwitch),
                ],
              ),
              ElevatedButton(
                onPressed: saveForm,
                child: const Text('Add Data'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  var dbQuery = await DatabaseHelper.getData('taskData');
                  debugPrint(dbQuery.toString());
                },
                child: const Text('Get Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
