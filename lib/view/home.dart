import 'package:flutter/material.dart';
import '../model/goals_model.dart';
import '../viewModels/goals_viewmodel.dart';
import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MainPage> {
  final CarouselController controller = CarouselController(initialItem: 1);
  final addGoalController = TextEditingController();
  late Future<List<dynamic>> futureGoals;
    // final _apiServices = GoalsListModel();

  @override
  void initState() {
    super.initState();
    futureGoals = GoalsViewModel.fetchGoals();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          const Icon(Icons.list, size: 30),
          const Icon(Icons.add, size: 30),
          const Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.yellow.shade100,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          if (index == 1) {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 600,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Enter your goal'),
                        const SizedBox(height: 30),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: TextField(
                              controller: addGoalController,
                            )),
                        ElevatedButton(
                          child: const Text('Submit'),
                          onPressed: () => {Navigator.pop(context)},
                        ),
                        ElevatedButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        letIndexChange: (index) => true,
      ),
      body: 
      
      SafeArea(
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
                  children:
                      snapshot.data!
                          .map((Goal item) => HeroLayoutCard(
                                goal: item,
                              ))
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

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          ClipRect(
            child: OverflowBox(
              maxWidth: width * 7 / 8,
              minWidth: width * 7 / 8,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/material/content_based_color_scheme_${goal.goalId}.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  goal.goalTitle,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  goal.goalTitle,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
          ),
        ]);
  }
}
