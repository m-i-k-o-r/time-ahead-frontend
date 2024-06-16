import 'package:first_flutter_app/myApp/activity/activity_viewing.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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