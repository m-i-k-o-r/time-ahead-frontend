import 'package:flutter/material.dart';
import '../widgetos.dart';

class Habit {
  final String name; // Название привычки
  bool isChecked; // Состояние чекбокса
  final bool hasNotification; // Имеет ли привычка уведомление

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
  int _selectedIndex = 0; // Начальный индекс для IndexedStack

  // Список привычек
  List<Habit> habits = [
    Habit(name: 'Утренняя зарядка'),
    Habit(name: 'Стакан воды утром'),
    Habit(name: 'Прогулка 30 минут'),
    Habit(name: 'Медитация'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Используем CustomAppBar
      body: IndexedStack(
        index: _selectedIndex, // Используем _selectedIndex для переключения окон
        children: [
          // Первый экран с привычками
          ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              Habit habit = habits[index];
              return Padding(
                padding: EdgeInsets.all(5.0), // Отступы для овальной формы
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Овальные границы
                  child: Container(
                    color: Colors.green, // Цвет фона
                    child: ListTile(
                      leading: Checkbox(
                        value: habit.isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            habit.isChecked = value ?? false; // Обновляет состояние чекбокса
                          });
                        },
                      ),
                      title: Text(
                        habit.name,
                        style: TextStyle(
                          decoration: habit.isChecked
                              ? TextDecoration.lineThrough // Зачеркивание текста при отметке
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Icon(
                        habit.hasNotification
                            ? Icons.notifications // Значок уведомления
                            : Icons.notifications_off,
                        color: Colors.indigo, // Цвет значка
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Center(child: Text('Второй экран')), // Экран 1
          Center(child: Text('Третий экран')), // Экран 2
          Center(child: Text('Четвертый экран')), // Экран 3
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex, // Передаем текущий индекс
        onItemTapped: (int index) {
          setState(() {
            _selectedIndex = index; // Обновляет _selectedIndex
          });
        },
      ),
    );
  }
}
