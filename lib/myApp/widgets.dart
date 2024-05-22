import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'activity/activity_list.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _selectedDay = 'Сегодня';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: AppBar(
          backgroundColor: AppColors.blueWhite,
          elevation: 0,
          actions: [
            DropdownButtonHideUnderline(
              child: Center(
                child: DropdownButton<String>(
                  value: _selectedDay,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.indigo,
                  style: const TextStyle(color: Colors.white),
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

class DaySlider extends StatefulWidget {
  const DaySlider({super.key});

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

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysOfWeek.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIndex == index
                    ? AppColors.darkBlue
                    : AppColors.white,
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

class Activity {
  String title;
  String category;
  String description;
  DateTime startTime;
  DateTime endTime;
  DateTime date;
  bool isCompleted;

  Activity({
    required this.title,
    required this.category,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.isCompleted = false,
  });
}

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onCompleted;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final bool isCurrentActivity;

  const ActivityTile({super.key,
    required this.activity,
    this.onCompleted,
    this.onEdit,
    required this.onDelete,
    required this.isCurrentActivity,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = activity.isCompleted;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityDetailScreen(
              activity: activity,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.white : AppColors.darkBlue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activity.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black : AppColors.white,
                ),
              ),
              if (!isCompleted)
                ElevatedButton(
                  onPressed: onCompleted,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.darkBlue, backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                  child: const Text('Завершить'),
                ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateFormat('HH:mm').format(activity.startTime)} - ${DateFormat('HH:mm').format(activity.endTime)}',
                style: TextStyle(color: isCompleted ? AppColors.darkBlue : AppColors.white),
              ),
              Text(
                "${activity.category} ",
                style: TextStyle(color: isCompleted ? AppColors.darkBlue : AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
