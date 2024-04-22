import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar();

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60); // Размер AppBar
}

class _CustomAppBarState extends State<CustomAppBar> {
  // Устанавливаем начальное значение на одно из существующих значений
  String _selectedDay = 'Сегодня';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDay, // Начальное значение
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.indigo,
              style: TextStyle(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
              items: ['Сегодня', 'Вчера', 'Последние 7 дней']
                  .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex; // Передается из родительского виджета
  final Function(int) onItemTapped; // Функция обратного вызова

  CustomNavigationBar({
    required this.selectedIndex, // Получаем текущий индекс
    required this.onItemTapped, // Получаем функцию обратного вызова
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25), // Скругление верхнего левого угла
        topRight: Radius.circular(25), // Скругление верхнего правого угла
      ),
      child: NavigationBar(
        backgroundColor: Colors.indigo,
        selectedIndex: selectedIndex, // Используем для выделения активного элемента
        onDestinationSelected: onItemTapped, // Привязка к функции обратного вызова
        destinations: [
          NavigationDestination(
            label: 'Активность',
            icon: Image.asset('assets/icons/activity.png'), // Пример иконки
          ),
          NavigationDestination(
            label: 'Задачи',
            icon: Image.asset('assets/icons/to-do.png'), // Пример иконки
          ),
          NavigationDestination(
            label: 'Привычки',
            icon: Image.asset('assets/icons/habit.png'),
          ),
          NavigationDestination(
            label: 'Профиль',
            icon: Image.asset('assets/icons/profile.png'),
          )
        ],
      ),
    );
  }
}
