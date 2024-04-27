import 'package:first_flutter_app/myApp/habits/habits_list.dart';
import 'package:first_flutter_app/myApp/screen_manager.dart';
import 'package:flutter/material.dart';


class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //title: 'Авторизация',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScreenManager(),
    );
  }
}