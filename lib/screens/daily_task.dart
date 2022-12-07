import 'package:data_entry/models/task_data.dart';
import 'package:data_entry/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyTask extends StatefulWidget {
  static const routeName = 'daily-screen';
  const DailyTask({super.key});

  @override
  State<DailyTask> createState() => _DailyTaskState();
}

class _DailyTaskState extends State<DailyTask> {
  @override
  Widget build(BuildContext context) {
    // var taskDate = Provider.of<TaskData>(context, listen: false).taskData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Task'),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: Provider.of<TaskData>(context, listen: false).getAndSetTask(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<TaskData>(
                child: const Center(
                  child: Text('Got no task yet, Start adding some..!!'),
                ),
                builder: (context, taskData, ch) {
                  var currentDate =
                      DateFormat('dd/MM/yyyy').format(DateTime.now());
                  debugPrint('CHECK : ${currentDate.toString()}');
                  if (taskData.taskData.isEmpty) return ch as Widget;

                  if (currentDate == taskData.taskData.first.date) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              Provider.of<TaskData>(context, listen: false)
                                  .deleteTask(taskData.taskData[index].name);
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          endActionPane: const ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: null,
                                backgroundColor: Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.notifications,
                                label: 'Notification',
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            child: ListTile(
                              title: Text(taskData.taskData[index].name),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                    backgroundColor: const Color.fromARGB(
                                        255, 191, 210, 226),
                                    content: SizedBox(
                                      height: 140,
                                      width: 350,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              'Task Name : ${taskData.taskData[index].name}'),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              'date : ${taskData.taskData[index].date}'),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              'Time : ${taskData.taskData[index].time}'),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              'IsAlert : ${taskData.taskData[index].alertMe}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                        
                      },
                      itemCount: taskData.taskData.length,
                    );
                  }
                  return Container();
                },
              ),
      ),
    );
  }
}
