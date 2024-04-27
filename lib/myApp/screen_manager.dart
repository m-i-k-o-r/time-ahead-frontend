import 'package:first_flutter_app/myApp/activity/activity_list.dart';
import 'package:first_flutter_app/myApp/habits/habits_list.dart';
import 'package:first_flutter_app/myApp/profile/profile_page.dart';
import 'package:first_flutter_app/myApp/tasks/to-do_list.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';

class ScreenManager extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<ScreenManager> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ActivityList(), // Экран активностей
    ToDoList(),
    HabitTrackerScreen(),// Экран задач
    ProfilePage() // Экран профиля
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}