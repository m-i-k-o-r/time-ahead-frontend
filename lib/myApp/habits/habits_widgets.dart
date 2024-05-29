import 'package:first_flutter_app/myApp/habits/habit_making.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_colors.dart';

class Habit {
  final String name;
  final String description;
  bool isChecked;
  final bool hasNotification;
  final TimeOfDay reminderTime;
  final Set<int> selectedDays;

  Habit({
    required this.name,
    required this.description,
    this.isChecked = false,
    this.hasNotification = true,
    required this.reminderTime,
    required this.selectedDays,
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

        bool shouldInsertDivider = (index > 0 &&
            !_getSortedHabits()[index - 1].isChecked && habit.isChecked);

        if (shouldInsertDivider) {
          return Column(
            children: [
              SvgPicture.asset(
                'assets/icons/circle-divider.svg',
                height: 20,
              ),
              _buildHabitListTile(habit, context),
            ],
          );
        }
        else {
          return _buildHabitListTile(habit, context);
        }
      },
    );
  }

  Widget _buildHabitListTile(Habit habit, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: AppColors.white,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitCreationScreen(
                    habitData: HabitData(
                      title: habit.name,
                      description: habit.description,
                      reminderTime: habit.reminderTime,
                      selectedDays: habit.selectedDays,
                    ),

                  ),
                ),
              );
            },
            leading: GestureDetector(
              onTap: () {
                onToggleCheck(habit);
              },
              child: SvgPicture.asset(
                habit.isChecked
                    ? 'assets/icons/check-circle.svg'
                    : 'assets/icons/circle.svg',
                width: 24,
                height: 24,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: habit.isChecked ? FontWeight.normal : FontWeight
                        .bold,
                    decoration: habit.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: habit.isChecked ? AppColors.blueWhite.withOpacity(
                        0.9) : Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/calendar-log.svg'),

                    SizedBox(width: 10),
                    Text(
                      '${_getSelectedDaysString(habit.selectedDays)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Column(
              children: [
                SvgPicture.asset('assets/icons/notification-true.svg'),
                SizedBox(height: 10),

                Text(
                  '${habit.reminderTime.hour}:${habit.reminderTime.minute.toString()
                      .padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSelectedDaysString(Set<int> selectedDays) {
    List<String> days = [];
    for (int day in selectedDays) {
      switch (day) {
        case 1:
          days.add('Пн');
          break;
        case 2:
          days.add('Вт');
          break;
        case 3:
          days.add('Ср');
          break;
        case 4:
          days.add('Чт');
          break;
        case 5:
          days.add('Пт');
          break;
        case 6:
          days.add('Сб');
          break;
        case 7:
          days.add('Вс');
          break;
      }
    }
    return days.join(', ');
  }
}

class ReminderTimeButton extends StatefulWidget {
  final TimeOfDay? reminderTime;
  final Function(TimeOfDay) onPressed;

  ReminderTimeButton({this.reminderTime, required this.onPressed});

  @override
  _ReminderTimeButtonState createState() => _ReminderTimeButtonState();
}

class _ReminderTimeButtonState extends State<ReminderTimeButton> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.reminderTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay initialTime = selectedTime ?? TimeOfDay.now();
        final TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );

        if (newTime != null) {
          setState(() {
            selectedTime = newTime;
          });
          widget.onPressed(newTime);
        }
      },

      child: Container(
        height: 60.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.blueWhite.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'время напоминания',
                  style: TextStyle(
                    color: AppColors.blueWhite,
                  ),
                ),
                SizedBox(width: 10),
                SvgPicture.asset('assets/icons/pencil.svg')
              ],
            ),
            Center(
              child: Container(
                child: Text(
                  selectedTime != null
                      ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                      : '__:__',
                  style: TextStyle(
                    color: Color(0xFF6F78A1),
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  CustomTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: backgroundColor,
          contentPadding: EdgeInsets.fromLTRB(20, 25, 0, 0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(
            color: textColor.withOpacity(0.5),
          ),
          labelStyle: TextStyle(
            color: AppColors.darkBlue,
          ),
        ),
        style: TextStyle(
          color: textColor,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
