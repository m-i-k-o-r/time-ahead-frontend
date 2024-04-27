import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_colors.dart';

class Habit {
  final String name;
  bool isChecked;
  final bool hasNotification;

  Habit({
    required this.name,
    this.isChecked = false,
    this.hasNotification = true,
  });
}

class HabitsList extends StatelessWidget {
  final List<Habit> habits;
  final Function(Habit) onToggleCheck;

  const HabitsList({
    Key? key,
    required this.habits,
    required this.onToggleCheck,
  }) : super(key: key);

  List<Habit> _getSortedHabits() {
    List<Habit> sortedHabits = List.from(habits);
    sortedHabits.sort((a, b) {
      int aValue = a.isChecked ? 1 : 0;
      int bValue = b.isChecked ? 1 : 0;

      return aValue.compareTo(bValue);
    });
    return sortedHabits;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _getSortedHabits().length,
      itemBuilder: (context, index) {
        Habit habit = _getSortedHabits()[index];

        bool shouldInsertDivider = (index > 0 && !_getSortedHabits()[index - 1].isChecked && habit.isChecked);

        if (shouldInsertDivider) {
          return Column(
            children: [
              SvgPicture.asset(
                'assets/icons/divider.svg', // Ваш SVG файл
                height: 20, // Примерный размер
              ),
              _buildHabitListTile(habit),
            ],
          );
        }
        else {
          return _buildHabitListTile(habit);
        }
      },
    );
  }

  Widget _buildHabitListTile(Habit habit) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: AppColors.white,
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                onToggleCheck(habit); // Функция обратного вызова для переключения состояния
              },
              child: SvgPicture.asset(
                habit.isChecked
                    ? 'assets/icons/check-circle.svg'
                    : 'assets/icons/circle.svg',
                width: 24,
                height: 24,
              ),
            ),
            title: Text(
              habit.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: habit.isChecked ? FontWeight.normal : FontWeight.bold,
                decoration: habit.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                color: habit.isChecked ? AppColors.blueWhite.withOpacity(0.9) : Colors.black,
              ),
            ),
            trailing: SvgPicture.asset(
              habit.hasNotification
                  ? 'assets/icons/notification-true.svg'
                  : 'assets/icons/notification-false.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
