import 'package:flutter/material.dart';
import '../viewModels/goals_viewmodel.dart';
import '../model/goals_model.dart';
import 'dart:math';

class GoalsView extends StatelessWidget {
  GoalsView({super.key});
  final CarouselController controller = CarouselController(initialItem: 1);
  final addGoalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SafeArea(
        child: FutureBuilder(
          future: GoalsViewModel.fetchGoals(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height / 2),
                child: CarouselView.weighted(
                  controller: controller,
                  itemSnapping: true,
                  flexWeights: const <int>[1, 7, 1],
                  //WARNING
                  children: snapshot.data!
                      .map((Goal item) => Container(
                          color: Colors.black,
                          child: HeroLayoutCard(
                            goal: item,
                          )))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class HeroLayoutCard extends StatelessWidget {
  const HeroLayoutCard({
    super.key,
    required this.goal,
  });
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

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(alignment: Alignment.center, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            Text(
              goal.date.day.toString(),
              overflow: TextOverflow.clip,
              softWrap: false,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              getWeekdayName(goal.date.weekday),
              overflow: TextOverflow.clip,
              softWrap: false,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              goal.goalTitle,
              overflow: TextOverflow.clip,
              softWrap: false,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 10),
            for (String goalDescription in goal.goalList)
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.5),
                        color: Color.fromARGB(255, Random().nextInt(255),
                            Random().nextInt(255), Random().nextInt(1))),
                  ),
                  SizedBox(width: 5),
                  Text(
                    goalDescription,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color.fromARGB(255, 178, 172, 172)),
                  )
                ],
              )
          ],
        ),
      ),
    ]);
  }
}
