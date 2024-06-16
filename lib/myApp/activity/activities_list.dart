import 'package:first_flutter_app/myApp/activity/activities_widgets.dart';
import 'package:first_flutter_app/myApp/activity/activity_creating.dart';
import 'package:first_flutter_app/myApp/activity/activity_editing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../widgets.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';


class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  ActivityListState createState() => ActivityListState();

  List<String> getCategories() {
    return ActivityListState.categories;
  }
}

class ActivityListState extends State<ActivityList> {
  static const String noCategory = 'Без категории';
  static List<String> categories = ['Работа', 'Учёба', 'Спорт'];

  DateTime _currentDate = DateTime.now();
  Map<DateTime, List<Activity>> activities = {};

  void _deleteActivity(DateTime date, int index) {
    setState(() {
      activities[date]!.removeAt(index);
    });
    if (activities[date]!.isEmpty) {
      activities.remove(date);
    }
  }

  void _addActivity(String title, String category, String description, DateTime startTime, DateTime endTime) {
    final currentDate = _currentDate;

    final newActivity = Activity(
      title: title,
      category: category,
      description: description,
      startTime: startTime,
      endTime: endTime,
      date: currentDate,
      isCompleted: false,
    );

    setState(() {
      final currentActivities = activities[currentDate] ?? [];
      currentActivities.add(newActivity);
      activities[currentDate] = currentActivities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allActivities = activities[_currentDate] ?? [];
    allActivities.sort((a, b) {
      int startCompare = a.startTime.compareTo(b.startTime);
      if (startCompare != 0) return startCompare;
      int endCompare = a.endTime.compareTo(b.endTime);
      if (endCompare != 0) return endCompare;
      return a.title.compareTo(b.title);
    });

    final incompleteActivities = allActivities.where((activity) => !activity.isCompleted).toList();
    final completedActivities = allActivities.where((activity) => activity.isCompleted).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueWhite,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkBlue),
                            onPressed: () {
                              setState(() {
                                _currentDate = _currentDate.subtract(const Duration(days: 1));
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('d MMMM').format(_currentDate),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Image.asset(
                                'assets/icons/activity.png',
                                color: AppColors.darkBlue,
                                height: 24.0,
                                width: 24.0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: AppColors.darkBlue),
                            onPressed: () {
                              setState(() {
                                _currentDate = _currentDate.add(const Duration(days: 1));
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 0.0),
              ],
            ),
          ),
          const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
          Expanded(
            child: ListView(
              children: [
                ...incompleteActivities.map((activity) => ActivityTile(
                  activity: activity,
                  onCompleted: () {
                    setState(() {
                      activity.isCompleted = true;
                    });
                  },
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditActivityScreen(
                        activity: activity,
                        onUpdate: (updatedActivity) {
                          setState(() {
                            activities[activity.date]![activities[activity.date]!.indexOf(activity)] = updatedActivity;
                          });
                        },
                        onDelete: (date, index) {
                          _deleteActivity(date, index);
                        },
                        activities: activities,
                      ),
                    ),
                  ),
                  onDelete: () => _deleteActivity(_currentDate, allActivities.indexOf(activity)),
                  isCurrentActivity: false,
                )),
                const SizedBox(height: 0.0),
                const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
                const SizedBox(height: 0.0),
                ...completedActivities.map((activity) => ActivityTile(
                  activity: activity,
                  onCompleted: null,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditActivityScreen(
                        activity: activity,
                        onUpdate: (updatedActivity) {
                          setState(() {
                            activities[activity.date]![activities[activity.date]!.indexOf(activity)] = updatedActivity;
                          });
                        },
                        onDelete: (date, index) {
                          _deleteActivity(date, index);
                        },
                        activities: activities,
                      ),
                    ),
                  ),
                  onDelete: () => _deleteActivity(_currentDate, allActivities.indexOf(activity)),
                  isCurrentActivity: false,
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 70,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddActivityScreen(
                    onAdd: _addActivity,
                    getCategories: () => categories,
                  ),
                ),
              ),
              child: SvgPicture.asset('assets/icons/add.svg'),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



