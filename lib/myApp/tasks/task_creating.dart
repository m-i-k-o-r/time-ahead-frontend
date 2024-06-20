import 'package:first_flutter_app/myApp/app_colors.dart';
import 'package:first_flutter_app/myApp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(String title, String description, DateTime dueDateTime) onAdd;

  const AddTaskScreen({super.key, required this.onAdd});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _dueDateTime;

  @override
  void initState() {
    super.initState();
    _dueDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 38.0, 8.0, 8.0),
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
                  ],
                ),
              ),
            ),
          ),
          const SvgDivider(svgPath: 'assets/icons/dividers/divider.svg'),
          Expanded(
            child: Form(
              key: _formKey,
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
                            errorStyle: TextStyle(color: AppColors.darkBlue),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Название задачи не может быть пустым!';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onAdd(
                    _titleController.text,
                    _descriptionController.text,
                    _dueDateTime,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ),
        ],
      ),
    );
  }
}