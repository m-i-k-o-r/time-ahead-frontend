import 'package:first_flutter_app/myApp/screen_manager.dart';
import 'package:flutter/material.dart';


class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenManager(),
    );
  }
}