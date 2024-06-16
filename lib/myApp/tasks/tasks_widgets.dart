import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:first_flutter_app/myApp/tasks/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(int) onDelete;
  final Function(int) onToggleCompletion;
  final int taskIndex;
  final Function() onViewTask;

  const TaskTile({super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.taskIndex,
    required this.onViewTask,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewTask,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: AppColors.darkBlue,
                  ),
                  onPressed: () => onToggleCompletion(taskIndex),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        color: task.isCompleted ? AppColors.blueWhite :Colors.black,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm dd.MM.yyyy').format(task.dueDateTime),
                      style: const TextStyle(color: AppColors.blueWhite),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}