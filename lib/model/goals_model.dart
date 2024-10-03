
class Goal {
  final int userId;
  final int goalId;
  final String goalTitle;
  final List<String> goalList;
  final DateTime date;

  const Goal(
      {required this.userId,required this.date, required this.goalId,required this.goalList, required this.goalTitle});
}
