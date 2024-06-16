import 'package:first_flutter_app/myApp/activity/activities_widgets.dart';
import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:first_flutter_app/myApp/activity/activities_list.dart';

class EditActivityScreen extends StatefulWidget {
  final Activity activity;
  final Function(Activity) onUpdate;
  final Function(DateTime, int) onDelete;
  final Map<DateTime, List<Activity>> activities;

  const EditActivityScreen({super.key,
    required this.activity,
    required this.onUpdate,
    required this.onDelete,
    required this.activities,
  });

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startTime;
  late DateTime _endTime;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activity.title);
    _descriptionController = TextEditingController(text: widget.activity.description);
    _startTime = widget.activity.startTime;
    _endTime = widget.activity.endTime;
    _selectedCategory = widget.activity.category.isEmpty ? null : widget.activity.category;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: const Text('Вы действительно хотите удалить эту активность?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(widget.activity.date, widget.activities[widget.activity.date]!.indexOf(widget.activity));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
                      'Название активности',
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
                            'Время начала',
                            style: TextStyle(
                              color: AppColors.blueWhite,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_startTime),
                              );
                              if (newTime != null) {
                                setState(() {
                                  _startTime = DateTime(
                                    _startTime.year,
                                    _startTime.month,
                                    _startTime.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            },
                            child: Text(
                              DateFormat('HH:mm').format(_startTime),
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
                  const SizedBox(width: 16.0),
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
                            'Время конца',
                            style: TextStyle(
                              color: AppColors.blueWhite,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          InkWell(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_endTime),
                              );
                              if (newTime != null) {
                                setState(() {
                                  _endTime = DateTime(
                                    _endTime.year,
                                    _endTime.month,
                                    _endTime.day,
                                    newTime.hour,
                                    newTime.minute,
                                  );
                                });
                              }
                            },
                            child: Text(
                              DateFormat('HH:mm').format(_endTime),
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
                      'Тип активности',
                      style: TextStyle(
                        color: AppColors.blueWhite,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String?>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      items: [null, ...ActivityListState.categories].map((category) {
                        return DropdownMenuItem<String?>(
                          value: category,
                          child: Text(
                            category ?? ActivityListState.noCategory,
                            style: const TextStyle(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
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
                      'Описание активности',
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
                    final updatedActivity = Activity(
                      title: _titleController.text,
                      category: _selectedCategory ?? '',
                      description: _descriptionController.text,
                      startTime: _startTime,
                      endTime: _endTime,
                      date: widget.activity.date,
                      isCompleted: widget.activity.isCompleted,
                    );
                    widget.onUpdate(updatedActivity);
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