class Task {
  final int userId;
  final String taskId;
   List<String>? tasks;
  final DateTime date;

   Task({
    required this.userId,
    required this.taskId,
     this.tasks,
    required this.date,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      userId: json['userId'],
      tasks: List<String>.from(json['tasks']),
      date: DateTime.parse(json['date']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'taskId': taskId,
      'tasks': tasks,
      'date': date.toIso8601String()
    };
  }
}
