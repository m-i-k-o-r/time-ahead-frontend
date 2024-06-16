import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:first_flutter_app/myApp/tasks/tasks_list.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdate;
  final Function() onDelete;

  const EditTaskScreen({super.key, required this.task, required this.onUpdate, required this.onDelete});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDateTime = widget.task.dueDateTime;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: const Text('Вы действительно хотите удалить эту задачу?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 38.0, 16.0, 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.darkBlue),
                          onPressed: _confirmDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
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
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
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
                          InkWell(
                            onTap: () async {
                              final newDate = await showDatePicker(
                                context: context,
                                initialDate: _dueDateTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (newDate != null) {
                                final newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(_dueDateTime),
                                );
                                if (newTime != null) {
                                  setState(() {
                                    _dueDateTime = DateTime(
                                      newDate.year,
                                      newDate.month,
                                      newDate.day,
                                      newTime.hour,
                                      newTime.minute,
                                    );
                                  });
                                }
                              }
                            },
                            child: Text(
                              DateFormat('HH:mm dd.MM.yyyy').format(_dueDateTime),
                              style: const TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
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
                    TextFormField(
                      controller: _descriptionController,
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final updatedTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDateTime: _dueDateTime,
                      isCompleted: widget.task.isCompleted,
                    );
                    widget.onUpdate(updatedTask);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}