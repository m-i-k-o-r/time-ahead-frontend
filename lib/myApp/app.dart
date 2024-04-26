import 'package:first_flutter_app/myApp/habbits/habits_list.dart';
import 'package:flutter/material.dart';
import 'firstUsing/login.dart';

class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Авторизация',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HabitTrackerScreen(),
    );
  }
}