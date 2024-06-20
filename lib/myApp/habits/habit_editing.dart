import 'package:first_flutter_app/myApp/habits/habits_widgets.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HabitEditScreen extends StatefulWidget {
  final Habit habit;
  final Function(Habit) onEdit;
  final VoidCallback onDelete;

  HabitEditScreen({
    Key? key,
    required this.habit,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _HabitEditScreenState createState() => _HabitEditScreenState();
}

class _HabitEditScreenState extends State<HabitEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay _reminderTime;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit.name);
    _descriptionController = TextEditingController(text: widget.habit.description);
    _reminderTime = widget.habit.reminderTime ?? TimeOfDay.now();
    _selectedDays = widget.habit.selectedDays.toSet();
  }

  final List<String> inactiveDayIcons = [
    'assets/icons/daysOfWeek/monday-non-active.svg',
    'assets/icons/daysOfWeek/tuesday-non-active.svg',
    'assets/icons/daysOfWeek/wednesday-non-active.svg',
    'assets/icons/daysOfWeek/thursday-non-active.svg',
    'assets/icons/daysOfWeek/friday-non-active.svg',
    'assets/icons/daysOfWeek/saturday-non-active.svg',
    'assets/icons/daysOfWeek/sunday-non-active.svg',
  ];

  final List<String> activeDayIcons = [
    'assets/icons/daysOfWeek/monday-active.svg',
    'assets/icons/daysOfWeek/tuesday-active.svg',
    'assets/icons/daysOfWeek/wednesday-active.svg',
    'assets/icons/daysOfWeek/thursday-active.svg',
    'assets/icons/daysOfWeek/friday-active.svg',
    'assets/icons/daysOfWeek/saturday-active.svg',
    'assets/icons/daysOfWeek/sunday-active.svg',
  ];

  void _saveHabit() {
    final updatedHabit = Habit(
      name: _titleController.text,
      description: _descriptionController.text,
      reminderTime: _reminderTime,
      selectedDays: _selectedDays,
    );

    widget.onEdit(updatedHabit);
    Navigator.pop(context);
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _selectAllDays() {
    setState(() {
      if (_selectedDays.length == 7) {
        _selectedDays.clear();
      } else {
        _selectedDays.addAll(List.generate(7, (index) => index + 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
            child: Container(
              height: 55.0,
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Редактирование привычки',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          children: [
                            const Text(
                              'название привычки',
                              style: TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset('assets/icons/pencil.svg')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 5),
                        child: TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SvgDivider(svgPath: 'assets/icons/dividers/divider.svg', padding: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Время напоминания',
                            style: TextStyle(
                              color: AppColors.blueWhite,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Text(
                            _formatTimeOfDay(_reminderTime),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int day = 1; day <= 7; day++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.85),
                        child: GestureDetector(
                          onTap: () => _toggleDay(day),
                          child: SvgPicture.asset(
                            _selectedDays.contains(day)
                                ? activeDayIcons[day - 1]
                                : inactiveDayIcons[day - 1],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                SvgDivider(svgPath: 'assets/icons/dividers/divider.svg', padding: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                        child: Row(
                          children: [
                            const Text(
                              'описание привычки',
                              style: TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset('assets/icons/pencil.svg')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 0),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: null,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: SvgPicture.asset('assets/icons/trash.svg'),
                    onPressed: widget.onDelete,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: _saveHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueWhite,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Сохранить',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }
}
