import 'package:flutter/material.dart';

class CalendargoalsView extends StatelessWidget {
  const CalendargoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amber,
      body: Center(child:Text('Screen1',style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),),),
    );
  }
}