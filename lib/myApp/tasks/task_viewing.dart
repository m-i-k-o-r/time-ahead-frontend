import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:first_flutter_app/myApp/tasks/tasks_list.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 38.0, 16, 16),
            child: Container(
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.darkBlue),
                        onPressed: onEdit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Название задачи',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        task.title,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg', padding: 4.0),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Время выполнения',
                              style: TextStyle(
                                color: AppColors.blueWhite,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              DateFormat('HH:mm dd.MM.yyyy').format(task.dueDateTime),
                              style: const TextStyle(
                                color: AppColors.darkBlue,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Описание задачи',
                        style: TextStyle(
                          color: AppColors.blueWhite,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        task.description,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}