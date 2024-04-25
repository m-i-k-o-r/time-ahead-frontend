import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar();

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50); // Размер AppBar
}

class _CustomAppBarState extends State<CustomAppBar> {
  // Устанавливаем начальное значение на одно из существующих значений
  String _selectedDay = 'Сегодня';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: AppBar(
          backgroundColor: AppColors.blueWhite,
          elevation: 0,
          actions: [
            DropdownButtonHideUnderline(
              child: Center(
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
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15) // Скругление верхнего правого угла
        ),
        child: NavigationBar(
          backgroundColor: AppColors.darkBlue,
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
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
        ),
      ),
    );
  }
}

class DaySlider extends StatefulWidget {
  @override
  _DaySliderState createState() => _DaySliderState();
}

class _DaySliderState extends State<DaySlider> {
  final List<String> daysOfWeek = [
    'Все',
    'Понедельник',
    'Вторник',
    'Среда',
    'Четверг',
    'Пятница',
    'Суббота',
    'Воскресенье'
  ];

  int _selectedIndex = 0; // Индекс выбранного дня недели

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysOfWeek.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = index; // Обновляем выбранный индекс
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIndex == index
                    ? AppColors.darkBlue
                    : AppColors.white, // Изменяем цвет в зависимости от выбранного индекса
              ),
              child: Text(
                daysOfWeek[index],
                style: TextStyle(
                  color: _selectedIndex == index
                      ? Colors.white
                      : AppColors.blueWhite,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


/*class FloatingActionButtonContainer extends StatelessWidget {
  final Widget child;

  FloatingActionButtonContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}*/

class SvgDivider extends StatelessWidget {
  final String svgPath = "assets/icons/divider.svg";
  final double padding; // Параметр отступа вокруг разделителя

  SvgDivider({required svgPath, this.padding = 16.0}); // Конструктор

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: padding), // Отступы сверху и снизу
      child: Center(
        child: SvgPicture.asset(
          svgPath, // Путь к вашей SVG-иконке
          width: 24, // Ширина иконки
          height: 24, // Высота иконки
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn), // Цвет иконки
        ),
      ),
    );
  }
}
