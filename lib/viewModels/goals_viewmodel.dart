import '../model/goals_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class GoalsViewModel {
  static Future<List<Goal>> fetchGoals() async {
    List<Goal> goalsList = [];
    final response = await http.get(
        Uri.parse('https://771d6b1d79cb44f8972ef87e561176bf.api.mockbin.io/'));

    final jsonData = jsonDecode(response.body);
    print("Works");
    if (response.statusCode == 200) {
      for (final eachGoal in jsonData['goals']) {
        final goal = Goal(
            goalId: eachGoal['goalId'],
            userId: eachGoal['userId'],
            goalTitle: eachGoal['goalTitle'],
            goalList: List<String>.from(eachGoal['goalList']),
            date: DateTime.parse(eachGoal['date']));

        goalsList.add(goal);
      }
      return goalsList;
    } else {
      throw Exception('Failed to load');
    }
  }
}
