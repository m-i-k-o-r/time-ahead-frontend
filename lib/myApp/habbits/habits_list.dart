import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';
import '../widgets.dart';

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

class HabitTrackerScreen extends StatefulWidget {
  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  int _selectedIndex = 0;

  List<Habit> habits = [
    Habit(name: 'Утренняя зарядка'),
    Habit(name: 'Стакан воды утром'),
    Habit(name: 'Прогулка 30 минут'),
    Habit(name: 'Медитация'),
  ];

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
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0),
          child: DaySlider(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            ListView.builder(
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
                } else {
                  return _buildHabitListTile(habit);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 80, // Увеличьте ширину, чтобы сделать кнопку шире
            child: FloatingActionButton(
              onPressed: () {
                // Действие при нажатии
              },
              child: SvgPicture.asset(
                'assets/icons/add.svg', // Ваша SVG-иконка
              ),
            ),
          ),
          SizedBox(height: 10),
          CustomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),

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
                setState(() {
                  habit.isChecked = !habit.isChecked;
                });
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
