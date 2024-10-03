import 'package:flutter/material.dart';
import '../viewModels/goals_viewmodel.dart';
import '../view/goals_view.dart';
import '../view/calendarTasks_localstorage_view.dart';
import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MainPage> {
  final CarouselController controller = CarouselController(initialItem: 1);
  final addGoalController = TextEditingController();
  late Future<List<dynamic>> futureGoals;
  List screens = [
    GoalsView(),
    CalendarTasks(),
  ];
  int _selectedIndex = 0;

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
          backgroundColor: Colors.black,
          title: const Text(
            "Planner",
            style: TextStyle(
                color: Colors.white, // Set the title color to white,
                letterSpacing: 2),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          items: const <Widget>[
            Icon(Icons.list, size: 30),
            Icon(Icons.list, size: 30),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
          buttonBackgroundColor: const Color.fromARGB(255, 250, 247, 247),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) {}
          },
          letIndexChange: (index) => true,
        ),
        body: screens[_selectedIndex]);
  }
}
