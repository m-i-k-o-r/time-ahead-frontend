import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar();

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(75);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _selectedDay = 'Все';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: AppBar(
          backgroundColor: AppColors.blueWhite,
          elevation: 20,
          titleSpacing: 0,
          title: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    elevation: 40,
                    value: _selectedDay,
                    iconSize: 24,
                    iconEnabledColor: Colors.black,
                    icon: Icon(Icons.arrow_drop_down),
                    style: TextStyle(color: Colors.blueGrey),
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDay = newValue!;
                      });
                    },
                    items: [
                      'Все',
                      'Понедельник',
                      'Вторник',
                      'Среда',
                      'Четверг',
                      'Пятница',
                      'Суббота',
                      'Воскресенье'
                    ].map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 18, color: AppColors.darkBlue),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)
        ),
        child: NavigationBar(
          backgroundColor: AppColors.darkBlue,
          selectedIndex: selectedIndex,
          onDestinationSelected: onItemTapped,
          destinations: [
            NavigationDestination(
              label: 'Активность',
              icon: Image.asset('assets/icons/activity.png'),
            ),
            NavigationDestination(
              label: 'Задачи',
              icon: Image.asset('assets/icons/to-do.png'),
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
          indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))
          ),
        ),
      ),
    );
  }
}

class SvgDivider extends StatelessWidget {
  final String svgPath = "assets/icons/dividers/divider.svg";
  final double padding;

  const SvgDivider({super.key, required svgPath, this.padding = 8.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: SvgPicture.asset(
          svgPath,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        ),
      ),
    );
  }
}

