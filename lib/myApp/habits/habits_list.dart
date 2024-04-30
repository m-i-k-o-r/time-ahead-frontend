import 'package:first_flutter_app/myApp/habits/habit_making.dart';
import 'package:first_flutter_app/myApp/habits/habits_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets.dart';

class HabitData {
  final String title;
  final String description;
  final TimeOfDay reminderTime;
  final Set<int> selectedDays;

  HabitData({
    required this.title,
    required this.description,
    required this.reminderTime,
    required this.selectedDays,
  });
}

class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TimeOfDay _reminderTime = TimeOfDay.now();
  Set<int> _selectedDays = {};

  List<Habit> habits = [
    Habit(name: 'Утренняя зарядка'),
    Habit(name: 'Стакан воды утром'),
    Habit(name: 'Прогулка 30 минут'),
    Habit(name: 'Медитация'),
  ];

  void _toggleHabitCheck(Habit habit) {
    setState(() {
      habit.isChecked = !habit.isChecked;
    });
  }

  void _createHabit() {
    final habitData = HabitData(
      title: _titleController.text,
      description: _descriptionController.text,
      reminderTime: _reminderTime,
      selectedDays: _selectedDays,
    );

    Navigator.pop(context, habitData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0),
          child: DaySlider(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: HabitsList(
          habits: habits,
          onToggleCheck: _toggleHabitCheck,
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 70,
            child: FloatingActionButton(
              onPressed: () async {
                final habitData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitCreationScreen(),
                  ),
                );

                if (habitData != null) {
                  setState(() {
                    habits.add(
                      Habit(
                        name: habitData.title,
                        isChecked: false,
                        hasNotification: habitData.selectedDays.isNotEmpty,
                      ),
                    );
                  });
                }
              },
              child: SvgPicture.asset('assets/icons/add.svg'),
            ),
          ),
        ),
      ),
    );
  }
}







