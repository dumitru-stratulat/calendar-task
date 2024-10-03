import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import 'dart:math';

class CalendarTasks extends ConsumerWidget {
  CalendarTasks({super.key});
  final addGoalController = TextEditingController();
  String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return "Invalid day";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(taskLocalStorageServiceProvider);

    return Scaffold(
        backgroundColor: Colors.black,
        body: tasksAsyncValue.when(
            data: (tasks) => ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Container(
                        height: 150,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: Column(
                                      children: [
                                        Text(
                                          getWeekdayName(task.date.weekday),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          task.date.day.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 110,
                                    ),
                                    width: 3.0,
                                    color: Colors.blue[300]),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              // Use Expanded to allow the widget to fill available space within the Row
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SizedBox(
                                              height: 600,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Text(
                                                        'Enter your goal'),
                                                    const SizedBox(height: 30),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 16),
                                                        child: TextField(
                                                          controller:
                                                              addGoalController,
                                                        )),
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Submit'),
                                                      onPressed: () => {
                                                        ref
                                                            .read(
                                                                taskLocalStorageServiceProvider
                                                                    .notifier)
                                                            .saveStringList(
                                                                addGoalController
                                                                    .text,
                                                                task,
                                                                index),
                                                        Navigator.pop(context)
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Close'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                          height: 100,
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  for (String taskTitle
                                                      in task.tasks ?? [])
                                                    Row(children: [
                                                      Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3.5),
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    Random()
                                                                        .nextInt(
                                                                            255),
                                                                    Random()
                                                                        .nextInt(
                                                                            255),
                                                                    Random()
                                                                        .nextInt(
                                                                            1))),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                        child: Text(
                                                          taskTitle,
                                                          style:
                                                              const TextStyle(
                                                                  letterSpacing:
                                                                      0.8,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      )),
                                                      GestureDetector(
                                                        onTap: () => ref
                                                            .read(
                                                                taskLocalStorageServiceProvider
                                                                    .notifier)
                                                            .deleteTask(
                                                                task,
                                                                taskTitle,
                                                                index),
                                                        child: const Text(
                                                            "Delete"),
                                                      )
                                                    ])
                                                ],
                                              ),
                                              const Text(
                                                "+ Add task",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 38, 37, 37)),
                                              )
                                            ],
                                          ))),
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err'))));
  }
}
