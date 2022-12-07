import 'package:data_entry/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/task_data.dart';

class AllTask extends StatefulWidget {
  static const routeName = '/all-task';
  const AllTask({super.key});

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  void deleteData(data) {
    Provider.of<TaskData>(context, listen: false).taskData.remove(data);
  }

  @override
  Widget build(BuildContext context) {
    // var dataTask = Provider.of<TaskData>(context).taskData;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Task'),
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
                builder: (context, datatask, ch) {
                  if (datatask.taskData.isEmpty) return ch as Widget;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {
                            Provider.of<TaskData>(context, listen: false)
                                .deleteTask(datatask.taskData[index].name);
                          }),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                setState(() {
                                  Provider.of<TaskData>(context, listen: false)
                                      .deleteTask(
                                          datatask.taskData[index].name);
                                });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                debugPrint(datatask.taskData[index].alertMe
                                    .toString());
                                setState(() {
                                  if (datatask.taskData[index].alertMe ==
                                      true) {
                                    datatask.taskData[index].alertMe = false;
                                  } else {
                                    datatask.taskData[index].alertMe = true;
                                  }
                                });
                                debugPrint(datatask.taskData[index].alertMe
                                    .toString());
                                Provider.of<TaskData>(context, listen: false)
                                    .updateTask(
                                        task: datatask.taskData[index].name,
                                        isAlert:
                                            datatask.taskData[index].alertMe);
                              },
                              backgroundColor: datatask.taskData[index].alertMe
                                  ? const Color(0xFF0392CF)
                                  : Colors.red,
                              foregroundColor: Colors.white,
                              icon: datatask.taskData[index].alertMe
                                  ? Icons.notifications
                                  : Icons.notifications_off,
                              label: 'Notification',
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(datatask.taskData[index].name),
                        ),
                      );
                    },
                    itemCount: datatask.taskData.length,
                  );
                }),
      ),
    );
  }
}
