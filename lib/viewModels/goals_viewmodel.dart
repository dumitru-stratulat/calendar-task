import '../model/goals_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';



class GoalsViewModel{
 static  Future<List<Goal>> fetchGoals() async {
  List<Goal> goalsList = [];
  final response = await http.get(
      Uri.parse('https://09617cb5f05e48439d8b84d2dfa2f167.api.mockbin.io/'));
  final jsonData = jsonDecode(response.body);

  if (response.statusCode == 200) {
    for (final eachGoal in jsonData['goals']) {
      final goal = Goal(
          goalId: eachGoal['goalId'],
          userId: eachGoal['userId'],
          goalTitle: eachGoal['goalTitle']);

      goalsList.add(goal);
    }
    return goalsList;
  } else {
    throw Exception('Failed to load');
  }
}
}