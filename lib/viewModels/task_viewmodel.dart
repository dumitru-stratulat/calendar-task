import '../model/task_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TaskViewModel extends AutoDisposeAsyncNotifier<List<Task>> {
  var uuid = Uuid();
  Future<List<Task>> fetchTasks() async {
    const String apiUrl =
        "https://a3729be481b34382b55456684e2da599.api.mockbin.io/";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['tasks'];
      print(jsonData);
      return jsonData.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Invalid day";
    }
  }

  @override
  Future<List<Task>> build() async {
    int userId = 1;
    String taskId = uuid.v1();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? loadedString = prefs.getString('daysWithTasks');
    final List<dynamic> jsonData = jsonDecode(loadedString!);
    List<Task> daysWithTasks =
        jsonData.map((json) => Task.fromJson(json)).toList();

    List<DateTime> existingDaysWithTasks = [];
    DateTime currentTime = DateTime.now();
    //adding in list the dates that have tasks
    for (var day in daysWithTasks) {
      existingDaysWithTasks.add(day.date);
    }
    //iterate 30 days and add in listdays with tasks and no tasks to return
    for (var i = 0; i < 30; i++) {
      bool found = false;
      DateTime iterationDay = currentTime.add(Duration(days: i));
      existingDaysWithTasks.forEach((date) {
        if (date.year == iterationDay.year &&
            date.month == iterationDay.month &&
            date.day == iterationDay.day) {
          found = true;
        }
      });
      if (!found) {
        daysWithTasks.add(Task(
            userId: userId, taskId: taskId, tasks: [], date: iterationDay));
      }
    }
    return daysWithTasks;
  }

  Future<void> saveStringList(String description, Task task, int index) async {
    //get data from storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedString = prefs.getString('daysWithTasks');
    final List<dynamic> jsonData = jsonDecode(loadedString!);
    List<Task> taskList = jsonData.map((json) => Task.fromJson(json)).toList();
    //if task list already exist in that day add, if not create the list of tasks
    int indexOfElementToAdd =
        taskList.indexWhere((el) => el.taskId == task.taskId);
    if (indexOfElementToAdd != -1) {
      taskList[indexOfElementToAdd].tasks!.add(description);
    } else {
      Task newTask = Task(
          taskId: task.taskId, tasks: task.tasks, userId: 1, date: task.date);
      newTask.tasks!.add(description);
      taskList.add(newTask);
    }
    String jsonString =
        jsonEncode(taskList.map((task) => task.toJson()).toList());
    await prefs.setString('daysWithTasks', jsonString);
    //state to update
    if (state.value != null) {
      state.value![index].tasks!.add(description);
    }

    final currentTasks = state.value ?? [];
    state = AsyncValue.data([...currentTasks]);
  }

  Future<void> deleteTask(Task task, String taskTitle, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedString = prefs.getString('daysWithTasks');
    final List<dynamic> jsonData = jsonDecode(loadedString!);

    List<Task> taskList = jsonData.map((json) => Task.fromJson(json)).toList();
    for (Task taskIteration in taskList) {
      if (taskIteration.taskId == task.taskId) {
        taskIteration.tasks!
            .removeWhere((taskTitleIterator) => taskTitleIterator == taskTitle);
      }
    }

    String jsonString =
        jsonEncode(taskList.map((task) => task.toJson()).toList());
    await prefs.setString('daysWithTasks', jsonString);

    if (state.value != null) {
      state.value![index].tasks!
          .removeWhere((taskDescription) => taskDescription == taskTitle);
    }
    final currentTasks = state.value ?? [];
    state = AsyncValue.data([...currentTasks]);
  }
}
