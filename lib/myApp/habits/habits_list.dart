import 'package:first_flutter_app/myApp/habits/habits_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets.dart';


class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {

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
          alignment: Alignment.bottomCenter, // Выравнивание по нижней центральной точке
          child: Container(
            width: 70,
            child: FloatingActionButton(
              onPressed: () {
                // Действие при нажатии на кнопку
              },
              child: SvgPicture.asset('assets/icons/add.svg'), // Иконка внутри кнопки
            ),
          ),
        ),
      ),
    );
  }
}






